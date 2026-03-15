import UIKit

final class ListingTableViewCell: UITableViewCell {
    static let reuseIdentifier = "ListingCell"

    // MARK: - UI Components

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let cityLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .systemBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let sofaTypeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let wifiLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout

    private func setupLayout() {
        let topRow = UIStackView(arrangedSubviews: [cityLabel, priceLabel])
        topRow.axis = .horizontal
        topRow.distribution = .equalSpacing
        topRow.translatesAutoresizingMaskIntoConstraints = false

        let bottomRow = UIStackView(arrangedSubviews: [sofaTypeLabel, wifiLabel])
        bottomRow.axis = .horizontal
        bottomRow.spacing = 12
        bottomRow.translatesAutoresizingMaskIntoConstraints = false

        let stack = UIStackView(arrangedSubviews: [titleLabel, topRow, bottomRow])
        stack.axis = .vertical
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
        ])
    }

    // MARK: - Configure

    func configure(with listing: Listing) {
        titleLabel.text = listing.title
        cityLabel.text = listing.city.displayName
        priceLabel.text = listing.priceDisplay
        sofaTypeLabel.text = listing.sofaType.displayName
        wifiLabel.text = listing.hasFreeWifi ? NSLocalizedString("wifi_included", comment: "") : NSLocalizedString("no_wifi", comment: "")
        wifiLabel.textColor = listing.hasFreeWifi ? .systemGreen : .systemGray
    }
}
