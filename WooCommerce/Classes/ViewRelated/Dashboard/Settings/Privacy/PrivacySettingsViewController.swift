import UIKit
import Gridicons

class PrivacySettingsViewController: UIViewController {

    /// Main TableView
    ///
    @IBOutlet weak var tableView: UITableView!

    /// Table Sections to be rendered
    ///
    private var sections = [Section]()

    // MARK: - Overridden Methods
    //
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigation()
        configureMainView()
        configureTableView()
        configureSections()
        registerTableViewCells()
    }
}


// MARK: - View Configuration
//
private extension PrivacySettingsViewController {

    func configureNavigation() {
        title = NSLocalizedString("Privacy settings", comment: "Privacy settings screen title")

        // Don't show the Settings title in the next-view's back button
        let backButton = UIBarButtonItem(title: String(),
                                         style: .plain,
                                         target: nil,
                                         action: nil)

        navigationItem.backBarButtonItem = backButton
    }

    func configureMainView() {
        view.backgroundColor = StyleManager.tableViewBackgroundColor
    }

    func configureTableView() {
        tableView.estimatedRowHeight = Constants.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = StyleManager.tableViewBackgroundColor
    }

    func configureSections() {
        sections = [
            Section(title: nil, rows: [.collectInfo, .shareInfo, .cookiePolicy]),
            Section(title: nil, rows: [.privacyInfo, .privacyPolicy]),
            Section(title: nil, rows: [.cookieInfo, .cookiePolicy]),
        ]
    }

    func registerTableViewCells() {
        for row in Row.allCases {
            tableView.register(row.type.loadNib(), forCellReuseIdentifier: row.reuseIdentifier)
        }
    }

    /// Cells currently configured in the order they appear on screen.
    ///
    func configure(_ cell: UITableViewCell, for row: Row, at indexPath: IndexPath) {
        switch cell {
        case let cell as BasicTableViewCell where row == .collectInfo:
            configureCollectInfo(cell: cell)
        case let cell as TopLeftImageTableViewCell where row == .shareInfo:
            configureShareInfo(cell: cell)
        case let cell as BasicTableViewCell where row == .cookiePolicy:
            configureCookiePolicy(cell: cell)
        case let cell as TopLeftImageTableViewCell where row == .privacyInfo:
            configurePrivacyInfo(cell: cell)
        case let cell as BasicTableViewCell where row == .privacyPolicy:
            configurePrivacyPolicy(cell: cell)
        case let cell as TopLeftImageTableViewCell where row == .cookieInfo:
            configureCookieInfo(cell: cell)
        default:
            fatalError()
        }
    }

    func configureCollectInfo(cell: BasicTableViewCell) {
        cell.imageView?.image = Gridicon.iconOfType(.stats)
        cell.imageView?.tintColor = StyleManager.defaultTextColor
        cell.textLabel?.text = NSLocalizedString("Collect information", comment: "Settings > Privacy Settings > collect info section. Label the `Collect information` toggle.")
        let toggleSwitch = UISwitch()
        toggleSwitch.setOn(true, animated: true)
        toggleSwitch.onTintColor = StyleManager.wooCommerceBrandColor
        cell.accessoryView = toggleSwitch
    }

    func configureShareInfo(cell: TopLeftImageTableViewCell) {
        cell.leftImageView?.image = Gridicon.iconOfType(.infoOutline)
        cell.leftImageView?.tintColor = StyleManager.defaultTextColor
        cell.label?.text = NSLocalizedString("Share information with our analytics tool about your use of services while logged in to your WordPress.com account.", comment: "Settings > Privacy Settings > collect info section. Explains what the 'collect information' toggle is collecting")
    }

    func configureCookiePolicy(cell: BasicTableViewCell) {
        // To align the 'Learn more' cell to the others, add an "invisible" image.
        cell.imageView?.image = Gridicon.iconOfType(.image)
        cell.imageView?.tintColor = .white
        cell.textLabel?.text = NSLocalizedString("Learn more", comment: "Settings > Privacy Settings. A text link to the cookie policy.")
        cell.textLabel?.textColor = StyleManager.wooCommerceBrandColor
    }

    func configurePrivacyInfo(cell: TopLeftImageTableViewCell) {
        cell.leftImageView?.image = Gridicon.iconOfType(.userCircle)
        cell.leftImageView?.tintColor = StyleManager.defaultTextColor
        cell.label?.text = NSLocalizedString("This information helps us improve our products, make marketing to you more relevant, personalize your WordPress.com experience, and more as detailed in our privacy policy.", comment: "Settings > Privacy Settings > privacy info section. Explains what we do with the information we collect.")
    }

    func configurePrivacyPolicy(cell: BasicTableViewCell) {
        // To align the 'Read privacy policy' cell to the others, add an "invisible" image.
        cell.imageView?.image = Gridicon.iconOfType(.image)
        cell.imageView?.tintColor = .white
        cell.textLabel?.text = NSLocalizedString("Read privacy policy", comment: "Settings > Privacy Settings > privacy policy info section. A text link to the privacy policy.")
        cell.textLabel?.textColor = StyleManager.wooCommerceBrandColor
    }

    func configureCookieInfo(cell: TopLeftImageTableViewCell) {
        cell.leftImageView?.image = Gridicon.iconOfType(.briefcase)
        cell.leftImageView?.tintColor = StyleManager.defaultTextColor
        cell.label?.text = NSLocalizedString("We use other tracking tools, including some from third parties. Read about these and how to control them.", comment: "Settings > Privacy Settings > cookie info section. Explains what we do with the cookie information we collect.")
    }


    // MARK: Actions
    //
    func toggleCollectInfo() {
        // TODO: change the switch, change the variable, send the API request.
    }
}

// MARK: - Convenience Methods
//
private extension PrivacySettingsViewController {
    func rowAtIndexPath(_ indexPath: IndexPath) -> Row {
        return sections[indexPath.section].rows[indexPath.row]
    }
}


// MARK: - UITableViewDataSource Conformance
//
extension PrivacySettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].rows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = rowAtIndexPath(indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: row.reuseIdentifier, for: indexPath)
        configure(cell, for: row, at: indexPath)

        return cell
    }
}


// MARK: - Private Types
//
private struct Constants {
    static let rowHeight = CGFloat(44)
    static let separatorInset = CGFloat(16)
}

private struct Section {
    let title: String?
    let rows: [Row]
}

private enum Row: CaseIterable {
    case collectInfo
    case cookieInfo
    case cookiePolicy
    case privacyInfo
    case privacyPolicy
    case shareInfo

    var type: UITableViewCell.Type {
        switch self {
        case .collectInfo:
            return BasicTableViewCell.self
        case .cookieInfo:
            return TopLeftImageTableViewCell.self
        case .cookiePolicy:
            return BasicTableViewCell.self
        case .privacyInfo:
            return TopLeftImageTableViewCell.self
        case .privacyPolicy:
            return BasicTableViewCell.self
        case .shareInfo:
            return TopLeftImageTableViewCell.self
        }
    }

    var reuseIdentifier: String {
        return type.reuseIdentifier
    }
}
