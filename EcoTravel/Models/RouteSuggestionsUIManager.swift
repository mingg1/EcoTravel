import Foundation
import MapKit
import Polyline

/**
 * UI manager for the route suggestions view and route detail view
 * - Author: Minji Choi
 * - since: 2021-04-24
 */
class UIManager {
    /**
     * set color depending on the transport mode
     * - Parameter mapView: name of the transport mode
     * - Parameter mapView: name of the transport mode
     * - Parameter mapView: name of the transport mode
     * - Parameter mapView: name of the transport mode
     */
    func generateImageView(imgName: String, superView:UIStackView, mode:String, size:Int) {
        let imgView = UIImageView()
        imgView.image = UIImage(systemName: imgName)
        imgView.frame.size.width = CGFloat(size)
        imgView.frame.size.height = CGFloat(size)
        imgView.tintColor = RouteSuggestionsManager().setColor(mode)
        superView.addArrangedSubview(imgView)
        imgView.setContentHuggingPriority(.required, for: .horizontal)
    }

    /**
     * generate a stack view
     * - Parameter axis: axis of the stack view
     * - Parameter distribution: distribution of the stack view
     * - Parameter alignment: alignment of the stack view
     * - Parameter spacing: spacing amount between contents of the stack view
     * - Returns: a stack view with the settings
     */
    func generateStackView(axis:NSLayoutConstraint.Axis, distribution:UIStackView.Distribution, alignment:UIStackView.Alignment, spacing:CGFloat) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = axis
        stackView.distribution  = distribution
        stackView.alignment = alignment
        stackView.spacing = spacing
        return stackView
    }

    /**
     * generate an UILabel with bold styled text
     * - Parameter text: text of the label
     * - Parameter size: size of the label
     * - Returns: UILabel with bold styled text
     */
    func generateBoldTextLabel(text:String,size:CGFloat) -> UILabel {
        let textLabel = UILabel()
        textLabel.text = text
        textLabel.font = UIFont.boldSystemFont(ofSize: size)
        return textLabel
    }
}

/// UILabel with paddings
class UILabelPadding: UILabel {
    let padding = UIEdgeInsets(top: 1, left: 4, bottom: 1, right: 4)
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
    override var intrinsicContentSize : CGSize {
        let superContentSize = super.intrinsicContentSize
        let width = superContentSize.width + padding.left + padding.right
        let heigth = superContentSize.height + padding.top + padding.bottom
        return CGSize(width: width, height: heigth)
    }
}
