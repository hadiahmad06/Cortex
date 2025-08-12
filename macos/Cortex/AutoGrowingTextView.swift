import SwiftUI
import AppKit

struct AutoGrowingTextView: NSViewRepresentable {
    @Binding var text: String
    @Binding var isFirstResponder: Bool
    @Binding var measuredHeight: CGFloat

    let maxHeight: CGFloat
    let font: NSFont = .systemFont(ofSize: 12)

    func makeNSView(context: Context) -> NSScrollView {
        let scrollView = NSScrollView()
        scrollView.drawsBackground = false
        scrollView.hasVerticalScroller = false
        scrollView.hasHorizontalScroller = false
        scrollView.verticalScrollElasticity = .none
        scrollView.borderType = .noBorder

        let textView = FocusableTextView()
        textView.drawsBackground = false
        textView.backgroundColor = .clear
        textView.isRichText = false
        textView.isAutomaticQuoteSubstitutionEnabled = false
        textView.isAutomaticDashSubstitutionEnabled = false
        textView.isAutomaticTextReplacementEnabled = false
        textView.isAutomaticSpellingCorrectionEnabled = true
        textView.isEditable = true
        textView.isSelectable = true
        textView.allowsUndo = true
        textView.font = font
        textView.textColor = .white
        textView.insertionPointColor = .white
        textView.textContainerInset = NSSize(width: 0, height: 0)
        textView.textContainer?.lineFragmentPadding = 0
        textView.maxSize = NSSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        textView.isHorizontallyResizable = false
        textView.isVerticallyResizable = true
        textView.textContainer?.widthTracksTextView = true
        textView.autoresizingMask = [.width]

        // Ensure wrapping works and text remains visible/white while typing
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineBreakMode = .byWordWrapping
        textView.typingAttributes = [
            .foregroundColor: NSColor.labelColor,
            .font: font,
            .paragraphStyle: paragraph
        ]

        textView.delegate = context.coordinator
        textView.string = text

        scrollView.documentView = textView
        scrollView.contentView.postsBoundsChangedNotifications = true

        context.coordinator.scrollView = scrollView
        context.coordinator.textView = textView

        // Initial measure
        context.coordinator.recalculateHeight()

        return scrollView
    }

    func updateNSView(_ scrollView: NSScrollView, context: Context) {
        guard let textView = context.coordinator.textView else { return }

        if textView.string != text {
            textView.string = text
            context.coordinator.recalculateHeight()
        }

        // Reassert important properties
        textView.isEditable = true
        textView.isSelectable = true

        // Focus management
        if isFirstResponder {
            DispatchQueue.main.async {
                NSApp.activate(ignoringOtherApps: true)
                textView.window?.makeKeyAndOrderFront(nil)
                if textView.window?.firstResponder != textView {
                    textView.window?.makeFirstResponder(textView)
                }
            }
        }

        // Keep wrapping width in sync for correct height measurement
        let targetWidth = scrollView.contentSize.width
        if textView.textContainer?.containerSize.width != targetWidth {
            textView.textContainer?.containerSize = NSSize(width: targetWidth, height: CGFloat.greatestFiniteMagnitude)
            context.coordinator.recalculateHeight()
        }

        // Ensure scroller visibility matches height
        let needsScroll = measuredHeight > maxHeight
        scrollView.hasVerticalScroller = needsScroll
        scrollView.scrollerStyle = .overlay
        scrollView.verticalScrollElasticity = needsScroll ? .automatic : .none
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    final class Coordinator: NSObject, NSTextViewDelegate {
        var parent: AutoGrowingTextView
        weak var scrollView: NSScrollView?
        weak var textView: NSTextView?

        init(_ parent: AutoGrowingTextView) {
            self.parent = parent
        }

        func textDidChange(_ notification: Notification) {
            guard let textView = textView else { return }
            parent.text = textView.string
            recalculateHeight()
        }

        func recalculateHeight() {
            guard let textView = textView else { return }
            guard let container = textView.textContainer, let layout = textView.layoutManager else { return }

            // Ensure the layout is up to date for wrapping
            layout.ensureLayout(for: container)
            let glyphRange = layout.glyphRange(for: container)
            layout.ensureLayout(forGlyphRange: glyphRange)

            // Count the number of visual lines by iterating through the glyphs
            var totalHeight: CGFloat = 40
            var index = glyphRange.location
            
            while index < NSMaxRange(glyphRange) {
                var lineRange = NSRange()
                let lineRect = layout.lineFragmentRect(forGlyphAt: index, effectiveRange: &lineRange)
                totalHeight += NSMaxRange(glyphRange) - 1 == index ? 0 : lineRect.height
                index = NSMaxRange(lineRange)
            }

            let inset = textView.textContainerInset
            let height = ceil(totalHeight + inset.height * 2)

            let updateHeight = {
                self.parent.measuredHeight = height
                if let scrollView = self.scrollView {
                    let needsScroll = height > self.parent.maxHeight
                    scrollView.hasVerticalScroller = needsScroll
                    scrollView.scrollerStyle = .overlay
                    scrollView.verticalScrollElasticity = needsScroll ? .automatic : .none
                }
            }

            if Thread.isMainThread {
                updateHeight()
            } else {
                DispatchQueue.main.async { updateHeight() }
            }
        }
    }
}

// Custom NSTextView to reliably focus and activate window on click inside non-activating panels
final class FocusableTextView: NSTextView {
    override func mouseDown(with event: NSEvent) {
//        NSApp.activate(ignoringOtherApps: true)
//        window?.makeKeyAndOrderFront(nil)
//        window?.makeFirstResponder(self)
//        super.mouseDown(with: event)
    }
}
