import UIKit
import Combine

final class ResultsViewController: UIViewController {

    // MARK: - Properties

    private let query: SearchQuery
    private var viewModel: ResultsViewModel!
    private var listings: [Listing] = []
    private var cancellables = Set<AnyCancellable>()

    // MARK: - UI Components

    private let tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = 80
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        return tv
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.color = .heOrange
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("no_listings", comment: "")
        label.textAlignment = .center
        label.textColor = .heMuted
        label.font = .systemFont(ofSize: 16)
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Init

    init(query: SearchQuery) {
        self.query = query
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("results_title", comment: "")
        view.backgroundColor = .heSurface

        setupTableView()
        setupActivityIndicator()
        setupViewModel()
    }

    // MARK: - Setup

    private func setupTableView() {
        view.addSubview(tableView)
        view.addSubview(emptyLabel)
        tableView.register(ListingTableViewCell.self, forCellReuseIdentifier: ListingTableViewCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }

    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }

    private func setupViewModel() {
        viewModel = ResultsViewModel()

        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.handleState(state)
            }
            .store(in: &cancellables)

        viewModel.search(query: query)
    }

    // MARK: - State Handling

    private func handleState(_ state: ResultsViewModel.State) {
        switch state {
        case .idle:
            activityIndicator.stopAnimating()
            emptyLabel.isHidden = true

        case .loading:
            activityIndicator.startAnimating()
            emptyLabel.isHidden = true

        case .success(let result):
            activityIndicator.stopAnimating()
            listings = result
            tableView.reloadData()
            emptyLabel.isHidden = !result.isEmpty

        case .failure(let error):
            activityIndicator.stopAnimating()
            emptyLabel.isHidden = true
            let message = isConnectionError(error)
                ? NSLocalizedString("connection_error", comment: "")
                : error.localizedDescription
            let alert = UIAlertController(
                title: NSLocalizedString("error_title", comment: ""),
                message: message,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: NSLocalizedString("ok_button", comment: ""), style: .default))
            present(alert, animated: true)
        }
    }

    private func isConnectionError(_ error: Error) -> Bool {
        if let urlError = error as? URLError {
            return [.cannotConnectToHost, .networkConnectionLost, .notConnectedToInternet, .timedOut]
                .contains(urlError.code)
        }
        if let underlying = (error as NSError).userInfo[NSUnderlyingErrorKey] as? Error {
            return isConnectionError(underlying)
        }
        return false
    }
}

// MARK: - UITableViewDataSource

extension ResultsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        listings.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ListingTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? ListingTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: listings[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ResultsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
