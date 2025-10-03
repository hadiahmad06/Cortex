//
//  HStackWrapped.swift
//  Cortex
//
//  Created by Hadi Ahmad on 10/3/25.
//

import SwiftUI


// TODO: add alignment attribute
struct HStackWrapped<Content: View>: View {
  let spacingX: CGFloat
  let spacingY: CGFloat
  let content: Content
  
  init(
    spacingX: CGFloat = 8,
    spacingY: CGFloat = 6,
    @ViewBuilder content: () -> Content
  ) {
    self.spacingX = spacingX
    self.spacingY = spacingY
    self.content = content()
  }
  
  var body: some View {
    FlowLayout(spacingX: spacingX, spacingY: spacingY) {
      content
    }
  }
}

struct FlowLayout: Layout {
  var spacingX: CGFloat
  var spacingY: CGFloat
  
  func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
    var width: CGFloat = 0
    var height: CGFloat = 0
    var rowHeight: CGFloat = 0
    let maxWidth = proposal.width ?? .infinity
    
    for subview in subviews {
      let size = subview.sizeThatFits(.unspecified)
      if width + size.width > maxWidth {
        width = 0
        height += rowHeight + spacingY
        rowHeight = 0
      }
      width += size.width + spacingX
      rowHeight = max(rowHeight, size.height)
    }
    return CGSize(width: maxWidth, height: height + rowHeight)
  }
  
  func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
    var x: CGFloat = bounds.minX
    var y: CGFloat = bounds.minY
    var rowHeight: CGFloat = 0
    
    for subview in subviews {
      let size = subview.sizeThatFits(.unspecified)
      if x + size.width > bounds.maxX {
        x = bounds.minX
        y += rowHeight + spacingY
        rowHeight = 0
      }
      subview.place(at: CGPoint(x: x, y: y), proposal: ProposedViewSize(size))
      x += size.width + spacingX
      rowHeight = max(rowHeight, size.height)
    }
  }
}

#Preview {
  HStackWrapped {
    Text("text")
    Text("text2")
    Text("text3")
    Text("text4")
    Text("text5")
    Text("text6")
    Text("text7")
    Text("text8")
    Text("text9")
    Text("text10")
    Text("text11")
    Text("text12")
    Text("text13")
    Text("text14")
    Text("text15")
    Text("text16")
    Text("text17")
    Text("text18")
    Text("text19")
    Text("text20")
  }
  .frame(width: 400, height: 400)
}
