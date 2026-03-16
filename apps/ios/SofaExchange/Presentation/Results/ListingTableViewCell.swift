import UIKit

final class ListingTableViewCell: UITableViewCell {
    static let reuseIdentifier = "ListingCell"

    // MARK: - UI Components

    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.heGold.withAlphaComponent(0.35).cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let accentBar: UIView = {
        let view = UIView()
        view.backgroundColor = .heGold
        view.layer.cornerRadius = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .heNavy
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let cityLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .heMuted
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .heOrange
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let sofaTypeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .heNavy
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let wifiLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .semibold)
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
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none

        contentView.addSubview(cardView)
        cardView.addSubview(accentBar)

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
        stack.spacing = 6
        stack.translatesAutoresizingMaskIntoConstraints = false

        cardView.addSubview(stack)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),

            accentBar.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 10),
            accentBar.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 10),
            accentBar.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -10),
            accentBar.widthAnchor.constraint(equalToConstant: 4),

            stack.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            stack.leadingAnchor.constraint(equalTo: accentBar.trailingAnchor, constant: 10),
            stack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            stack.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12),
        ])
    }

    // MARK: - Configure

    func configure(with listing: Listing) {
        titleLabel.text = listing.title
        cityLabel.text = listing.city.displayName
        priceLabel.text = listing.priceDisplay
        sofaTypeLabel.text = listing.sofaType.displayName
        wifiLabel.text = listing.hasFreeWifi ? NSLocalizedString("wifi_included", comment: "") : NSLocalizedString("no_wifi", comment: "")
        wifiLabel.textColor = listing.hasFreeWifi ? UIColor(red: 0.184, green: 0.596, blue: 0.231, alpha: 1.0) : .heMuted
    }
}
