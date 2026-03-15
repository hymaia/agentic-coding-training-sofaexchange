import UIKit

final class SearchViewController: UIViewController {

    // MARK: - UI Components

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let cityLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("cities_label", comment: "")
        label.font = .boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let cityTableView: UITableView = {
        let tv = UITableView()
        tv.isScrollEnabled = false
        tv.layer.borderWidth = 1
        tv.layer.borderColor = UIColor.systemGray4.cgColor
        tv.layer.cornerRadius = 8
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    private let minPriceField: UITextField = {
        let tf = UITextField()
        tf.placeholder = NSLocalizedString("min_price_placeholder", comment: "")
        tf.keyboardType = .decimalPad
        tf.borderStyle = .roundedRect
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    private let maxPriceField: UITextField = {
        let tf = UITextField()
        tf.placeholder = NSLocalizedString("max_price_placeholder", comment: "")
        tf.keyboardType = .decimalPad
        tf.borderStyle = .roundedRect
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    private let wifiLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("free_wifi_label", comment: "")
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

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("app_name", comment: "")
        view.backgroundColor = .systemBackground
        setupScrollView()
        setupCityTableView()
        setupSearchButton()
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
        let cityTableHeight = CGFloat(cities.count) * 44

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
        sofaLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(cityLabel)
        contentView.addSubview(cityTableView)
        contentView.addSubview(priceStack)
        contentView.addSubview(wifiRow)
        contentView.addSubview(sofaLabel)
        contentView.addSubview(sofaTypeControl)
        contentView.addSubview(searchButton)

        NSLayoutConstraint.activate([
            cityLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            cityLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            cityLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),

            cityTableView.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 8),
            cityTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            cityTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            cityTableView.heightAnchor.constraint(equalToConstant: cityTableHeight),

            priceStack.topAnchor.constraint(equalTo: cityTableView.bottomAnchor, constant: padding),
            priceStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            priceStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),

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

    private func setupCityTableView() {
        cityTableView.register(UITableViewCell.self, forCellReuseIdentifier: "CityCell")
        cityTableView.dataSource = self
        cityTableView.delegate = self
    }

    private func setupSearchButton() {
        searchButton.addTarget(self, action: #selector(searchTapped), for: .touchUpInside)
    }

    // MARK: - Actions

    @objc private func searchTapped() {
        // Dismiss keyboard
        view.endEditing(true)

        // Parse price fields
        let minText = minPriceField.text ?? ""
        let maxText = maxPriceField.text ?? ""

        let minEuros = Double(minText)
        let maxEuros = Double(maxText)

        // Validation: if both are provided, max must be >= min
        if let min = minEuros, let max = maxEuros, max < min {
            let alert = UIAlertController(
                title: NSLocalizedString("invalid_price_range_title", comment: ""),
                message: NSLocalizedString("invalid_price_range_message", comment: ""),
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: NSLocalizedString("ok_button", comment: ""), style: .default))
            present(alert, animated: true)
            return
        }

        // Convert euros to cents
        viewModel.minPriceCents = minEuros.map { Int($0 * 100) }
        viewModel.maxPriceCents = maxEuros.map { Int($0 * 100) }

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

// MARK: - UITableViewDataSource

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath)
        let city = cities[indexPath.row]
        cell.textLabel?.text = city.displayName
        let isSelected = viewModel.selectedCities.contains(city)
        cell.accessoryType = isSelected ? .checkmark : .none
        return cell
    }
}

// MARK: - UITableViewDelegate

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let city = cities[indexPath.row]
        if let idx = viewModel.selectedCities.firstIndex(of: city) {
            viewModel.selectedCities.remove(at: idx)
        } else {
            viewModel.selectedCities.append(city)
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
