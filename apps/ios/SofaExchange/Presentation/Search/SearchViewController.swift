import UIKit

final class SearchViewController: UIViewController {

    // MARK: - UI Components

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let cityLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("cities_label", comment: "")
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .heNavy
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("price_label", comment: "")
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .heNavy
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let cityMenuButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentHorizontalAlignment = .left
        button.tintColor = .heMuted
        button.showsMenuAsPrimaryAction = true
        return button
    }()

    private let minPriceField: UITextField = {
        let tf = UITextField()
        tf.placeholder = NSLocalizedString("min_price_placeholder", comment: "")
        tf.keyboardType = .decimalPad
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    private let maxPriceField: UITextField = {
        let tf = UITextField()
        tf.placeholder = NSLocalizedString("max_price_placeholder", comment: "")
        tf.keyboardType = .decimalPad
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    private let wifiLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("free_wifi_label", comment: "")
        label.textColor = .heNavy
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let wifiSwitch: UISwitch = {
        let sw = UISwitch()
        sw.translatesAutoresizingMaskIntoConstraints = false
        return sw
    }()

    private let sofaTypeControl: UISegmentedControl = {
        let items = [
            NSLocalizedString("sofa_type_any", comment: ""),
            NSLocalizedString("sofa_type_sofa_bed", comment: ""),
            NSLocalizedString("sofa_type_simple_sofa", comment: ""),
        ]
        let sc = UISegmentedControl(items: items)
        sc.selectedSegmentIndex = 0
        sc.translatesAutoresizingMaskIntoConstraints = false
        return sc
    }()

    private let searchButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = NSLocalizedString("search_button", comment: "")
        config.cornerStyle = .medium
        let btn = UIButton(configuration: config)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    // MARK: - Properties

    private let viewModel = SearchViewModel()
    private let cities = City.allCases
    private var selectedCity: City? = nil

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = ""
        view.backgroundColor = .heSurface
        setupHeaderLogo()
        setupScrollView()
        setupCityMenu()
        setupSearchButton()
        applyBrandStyles()
        updateCityMenuButtonText()
    }

    // MARK: - Setup

    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])

        let padding: CGFloat = 16

        let priceStack = UIStackView(arrangedSubviews: [minPriceField, maxPriceField])
        priceStack.axis = .horizontal
        priceStack.distribution = .fillEqually
        priceStack.spacing = 8
        priceStack.translatesAutoresizingMaskIntoConstraints = false

        let wifiRow = UIStackView(arrangedSubviews: [wifiLabel, wifiSwitch])
        wifiRow.axis = .horizontal
        wifiRow.alignment = .center
        wifiRow.spacing = 8
        wifiRow.translatesAutoresizingMaskIntoConstraints = false

        let sofaLabel = UILabel()
        sofaLabel.text = NSLocalizedString("sofa_type_label", comment: "")
        sofaLabel.font = .boldSystemFont(ofSize: 16)
        sofaLabel.textColor = .heNavy
        sofaLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(cityLabel)
        contentView.addSubview(cityMenuButton)
        contentView.addSubview(priceLabel)
        contentView.addSubview(priceStack)
        contentView.addSubview(wifiRow)
        contentView.addSubview(sofaLabel)
        contentView.addSubview(sofaTypeControl)
        contentView.addSubview(searchButton)

        NSLayoutConstraint.activate([
            cityLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            cityLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            cityLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),

            cityMenuButton.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 8),
            cityMenuButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            cityMenuButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            cityMenuButton.heightAnchor.constraint(equalToConstant: 52),

            priceLabel.topAnchor.constraint(equalTo: cityMenuButton.bottomAnchor, constant: padding),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),

            priceStack.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 8),
            priceStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            priceStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            minPriceField.heightAnchor.constraint(equalToConstant: 52),
            maxPriceField.heightAnchor.constraint(equalToConstant: 52),

            wifiRow.topAnchor.constraint(equalTo: priceStack.bottomAnchor, constant: padding),
            wifiRow.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            wifiRow.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -padding),

            sofaLabel.topAnchor.constraint(equalTo: wifiRow.bottomAnchor, constant: padding),
            sofaLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            sofaLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),

            sofaTypeControl.topAnchor.constraint(equalTo: sofaLabel.bottomAnchor, constant: 8),
            sofaTypeControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            sofaTypeControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),

            searchButton.topAnchor.constraint(equalTo: sofaTypeControl.bottomAnchor, constant: padding * 2),
            searchButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            searchButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            searchButton.heightAnchor.constraint(equalToConstant: 50),
            searchButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding),
        ])
    }

    private func setupHeaderLogo() {
        let logoImageView = UIImageView(image: Self.loadLogoImage())
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false

        let container = UIView()
        container.addSubview(logoImageView)
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: container.topAnchor),
            logoImageView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            logoImageView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            logoImageView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 200),
            logoImageView.heightAnchor.constraint(equalToConstant: 40),
        ])
        navigationItem.titleView = container
    }

    private func setupCityMenu() {
        rebuildCityMenu()
    }

    private func setupSearchButton() {
        searchButton.addTarget(self, action: #selector(searchTapped), for: .touchUpInside)
    }

    private func applyBrandStyles() {
        [minPriceField, maxPriceField].forEach { textField in
            textField.borderStyle = .none
            textField.backgroundColor = .clear
            textField.textColor = .heNavy

            let spacer = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 1))
            textField.leftView = spacer
            textField.leftViewMode = .always
        }

        cityMenuButton.backgroundColor = .clear
        cityMenuButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        cityMenuButton.layer.borderWidth = 1
        cityMenuButton.layer.borderColor = UIColor.white.withAlphaComponent(0.30).cgColor

        wifiSwitch.onTintColor = .heOrange

        sofaTypeControl.selectedSegmentTintColor = .heOrange
        sofaTypeControl.setTitleTextAttributes([.foregroundColor: UIColor.heNavy], for: .normal)
        sofaTypeControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)

        var config = searchButton.configuration ?? UIButton.Configuration.filled()
        config.baseBackgroundColor = .heOrange
        config.baseForegroundColor = .white
        config.cornerStyle = .capsule
        searchButton.configuration = config

        applyGlassBackground(to: cityMenuButton, tint: UIColor.heGold.withAlphaComponent(0.20), interactive: true)
        applyGlassBackground(to: minPriceField, tint: UIColor.white.withAlphaComponent(0.10), interactive: false)
        applyGlassBackground(to: maxPriceField, tint: UIColor.white.withAlphaComponent(0.10), interactive: false)
    }

    private func applyGlassBackground(to view: UIView, tint: UIColor, interactive: Bool) {
        let glassView = UIVisualEffectView(effect: makeGlassEffect(tint: tint, interactive: interactive))
        glassView.translatesAutoresizingMaskIntoConstraints = false
        glassView.isUserInteractionEnabled = false
        glassView.layer.cornerRadius = 10
        glassView.clipsToBounds = true

        view.insertSubview(glassView, at: 0)
        NSLayoutConstraint.activate([
            glassView.topAnchor.constraint(equalTo: view.topAnchor),
            glassView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            glassView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            glassView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        view.layer.cornerRadius = 10
        view.clipsToBounds = true
    }

    private func makeGlassEffect(tint: UIColor, interactive: Bool) -> UIVisualEffect {
        if #available(iOS 26.0, *) {
            let effect = UIGlassEffect()
            effect.tintColor = tint
            effect.isInteractive = interactive
            return effect
        }
        return UIBlurEffect(style: .systemMaterial)
    }

    private func rebuildCityMenu() {
        let anyTitle = NSLocalizedString("sofa_type_any", comment: "")
        let actions = [UIAction(title: anyTitle, state: selectedCity == nil ? .on : .off) { [weak self] _ in
            self?.selectedCity = nil
            self?.updateCityMenuButtonText()
            self?.rebuildCityMenu()
        }] + cities.map { city in
            UIAction(title: city.displayName, state: self.selectedCity == city ? .on : .off) { [weak self] _ in
                self?.selectedCity = city
                self?.updateCityMenuButtonText()
                self?.rebuildCityMenu()
            }
        }
        cityMenuButton.menu = UIMenu(children: actions)
    }

    private func updateCityMenuButtonText() {
        let title = selectedCity?.displayName ?? NSLocalizedString("sofa_type_any", comment: "")
        cityMenuButton.setTitle(title, for: .normal)
        cityMenuButton.setTitleColor(.heNavy, for: .normal)
    }

    private static func loadLogoImage() -> UIImage? {
        if let image = UIImage(named: "sofa-exchange-logo") {
            return image
        }
        if let path = Bundle.main.path(forResource: "sofa-exchange-logo", ofType: "png") {
            return UIImage(contentsOfFile: path)
        }
        if let path = Bundle.main.path(forResource: "sofa-exchange-logo", ofType: "png", inDirectory: "Assets") {
            return UIImage(contentsOfFile: path)
        }
        return nil
    }

    // MARK: - Actions

    @objc private func searchTapped() {
        // Dismiss keyboard / picker
        view.endEditing(true)

        // City
        viewModel.selectedCities = selectedCity.map { [$0] } ?? []

        // WiFi
        viewModel.hasFreeWifi = wifiSwitch.isOn ? true : nil

        // Sofa type: 0 = Any, 1 = Sofa Bed, 2 = Simple Sofa
        switch sofaTypeControl.selectedSegmentIndex {
        case 1: viewModel.selectedSofaType = .sofaBed
        case 2: viewModel.selectedSofaType = .simpleSofa
        default: viewModel.selectedSofaType = nil
        }

        let query = viewModel.buildQuery()
        let resultsVC = ResultsViewController(query: query)
        navigationController?.pushViewController(resultsVC, animated: true)
    }
}
