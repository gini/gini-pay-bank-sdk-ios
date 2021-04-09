//
//  DigitalInvoiceViewController.swift
//  GiniPayBank
//
//  Created by Maciej Trybilo on 20.11.19.
//

import UIKit
import GiniPayApiLib
import GiniCapture
/**
 Delegate protocol for `DigitalInvoiceViewController`.
 */
public protocol DigitalInvoiceViewControllerDelegate: class {
    
    /**
     Called after the user taps the "Pay" button on the `DigitalInvoiceViewController`.
     
     - parameter viewController: The `DigitalInvoiceViewController` instance.
     - parameter invoice: The `DigitalInvoice` as amended by the user.
     */
    func didFinish(viewController: DigitalInvoiceViewController,
                   invoice: DigitalInvoice)
}

/**
 This class is a view controller that lets the user view their invoice
 together with the line items and total amount to pay. It will push the
 `LineItemDetailsViewController` onto the navigation stack when the user
 taps the "Edit" button on any of the line items.
 */
public class DigitalInvoiceViewController: UIViewController {

    /**
     The `DigitalInvoice` to display and amend by the user.
     */
    public var invoice: DigitalInvoice? {
        didSet {
            tableView.reloadData()
        }
    }
    
    public weak var delegate: DigitalInvoiceViewControllerDelegate?
    
    // TODO: This is to cope with the screen coordinator being inadequate at this point to support the return assistant step and needing a refactor.
    // Remove ASAP
    public var analysisDelegate: AnalysisDelegate?
    
    /**
     The `ReturnAssistantConfiguration` instance used by this class to customise its appearance.
     By default the shared instance is used.
     */
    public var returnAssistantConfiguration = ReturnAssistantConfiguration.shared
    
    private let tableView = UITableView()
    
    private var didShowOnboardInCurrentSession = false
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        title = .ginipayLocalized(resource: DigitalInvoiceStrings.screenTitle)

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: prefferedImage(named: "infoIcon"), style: .plain, target: self, action: #selector(whatIsThisTapped(source:)))
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        
        tableView.register(TextFieldTableViewCell.self,
                           forCellReuseIdentifier: "TextFieldTableViewCell")
        
        tableView.register(UINib(nibName: "DigitalLineItemTableViewCell",
                                 bundle: giniPayBankBundle()),
                           forCellReuseIdentifier: "DigitalLineItemTableViewCell")
        
        tableView.register(DigitalInvoiceAddonCell.self,
                           forCellReuseIdentifier: "DigitalInvoiceAddonCell")
        
        tableView.register(DigitalInvoiceTotalPriceCell.self,
                           forCellReuseIdentifier: "DigitalInvoiceTotalPriceCell")
        
        tableView.register(DigitalInvoiceFooterCell.self,
                           forCellReuseIdentifier: "DigitalInvoiceFooterCell")
        
        tableView.separatorStyle = .none
        
        tableView.contentInset = UIEdgeInsets(top: 25, left: 0, bottom: 0, right: 0)
        tableView.backgroundColor = UIColor.from(giniColor: returnAssistantConfiguration.digitalInvoiceBackgroundColor)
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showDigitalInvoiceOnboarding()
    }
    
    @objc func payButtonTapped() {
        
        guard let invoice = invoice else { return }
        delegate?.didFinish(viewController: self, invoice: invoice)
    }
    
    private func payButtonTitle() -> String {
        
        guard let invoice = invoice else {
            return .ginipayLocalized(resource: DigitalInvoiceStrings.noInvoicePayButtonTitle)
        }
        
        return String.localizedStringWithFormat(DigitalInvoiceStrings.payButtonTitle.localizedGiniPayFormat,
                                                invoice.numSelected,
                                                invoice.numTotal)
    }
    
    private func payButtonAccessibilityLabel() -> String {
        
        guard let invoice = invoice else {
            return .ginipayLocalized(resource: DigitalInvoiceStrings.noInvoicePayButtonTitle)
        }
        
        return String.localizedStringWithFormat(DigitalInvoiceStrings.payButtonTitleAccessibilityLabel.localizedGiniPayFormat,
                                                invoice.numSelected,
                                                invoice.numTotal)
    }
    
    @objc func whatIsThisTapped(source: UIButton) {
        
        let actionSheet = UIAlertController(title: .ginipayLocalized(resource: DigitalInvoiceStrings.whatIsThisActionSheetTitle),
                                            message: .ginipayLocalized(resource: DigitalInvoiceStrings.whatIsThisActionSheetMessage),
                                            preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: .ginipayLocalized(resource: DigitalInvoiceStrings.whatIsThisActionSheetActionHelpful),
                                            style: .default,
                                            handler: { _ in
                                                // TODO:
        }))
        
        actionSheet.addAction(UIAlertAction(title: .ginipayLocalized(resource: DigitalInvoiceStrings.whatIsThisActionSheetActionNotHelpful),
                                            style: .destructive,
                                            handler: { _ in
                                                // TODO:
        }))
        
        actionSheet.addAction(UIAlertAction(title: .ginipayLocalized(resource: DigitalInvoiceStrings.whatIsThisActionSheetActionCancel),
                                            style: .cancel,
                                            handler: nil))
        
        actionSheet.popoverPresentationController?.sourceView = source
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    fileprivate var onboardingWillBeShown: Bool {
        let key = "ginipaybank.defaults.digitalInvoiceOnboardingShowed"
        return UserDefaults.standard.object(forKey: key) == nil ? true : false
    }
    
    fileprivate func showDigitalInvoiceOnboarding() {
        if onboardingWillBeShown && !didShowOnboardInCurrentSession {
            let bundle = Bundle(for: type(of: self))
            let storyboard = UIStoryboard(name: "DigitalInvoiceOnboarding", bundle: bundle)
            let digitalInvoiceOnboardingViewController = storyboard.instantiateViewController(withIdentifier: "digitalInvoiceOnboardingViewController") as! DigitalInvoiceOnboardingViewController
            digitalInvoiceOnboardingViewController.returnAssistantConfiguration = returnAssistantConfiguration
            present(digitalInvoiceOnboardingViewController, animated: true)
            didShowOnboardInCurrentSession = true
        }
    }
    
}

extension DigitalInvoiceViewController: UITableViewDelegate, UITableViewDataSource {

    // MARK: - Table view data source

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    enum Section: Int, CaseIterable {
        case lineItems
        case addons
        case totalPrice
        case footer
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        switch Section(rawValue: section) {
        case .lineItems: return invoice?.lineItems.count ?? 0
        case .addons: return invoice?.addons.count ?? 0
        case .totalPrice: return 1
        case .footer: return 1
        default: fatalError()
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch Section(rawValue: indexPath.section) {
        case .lineItems:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "DigitalLineItemTableViewCell",
                                                     for: indexPath) as! DigitalLineItemTableViewCell
            if let invoice = invoice {
                cell.viewModel = DigitalLineItemViewModel(lineItem: invoice.lineItems[indexPath.row], returnAssistantConfiguration: returnAssistantConfiguration, index: indexPath.row, invoiceNumTotal: invoice.numTotal)
            }
            
            cell.delegate = self
            
            return cell
            
        case .addons:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "DigitalInvoiceAddonCell",
                                                     for: indexPath) as! DigitalInvoiceAddonCell
            cell.returnAssistantConfiguration = returnAssistantConfiguration
            if let invoice = invoice {
                let addon = invoice.addons[indexPath.row]
                cell.addonName = addon.name
                cell.addonPrice = addon.price
            }
            
            return cell
            
        case .totalPrice:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "DigitalInvoiceTotalPriceCell",
                                                     for: indexPath) as! DigitalInvoiceTotalPriceCell
            cell.returnAssistantConfiguration = returnAssistantConfiguration
            
            cell.totalPrice = invoice?.total
            
            return cell
            
        case .footer:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "DigitalInvoiceFooterCell",
                                                     for: indexPath) as! DigitalInvoiceFooterCell
            
            cell.returnAssistantConfiguration = returnAssistantConfiguration
            cell.payButton.setTitle(payButtonTitle(), for: .normal)
            cell.payButton.accessibilityLabel = payButtonAccessibilityLabel()
            cell.payButton.addTarget(self, action: #selector(payButtonTapped), for: .touchUpInside)

            return cell
            
        default: fatalError()
        }
    }
}

extension DigitalInvoiceViewController: DigitalLineItemTableViewCellDelegate {

    func modeSwitchValueChanged(cell: DigitalLineItemTableViewCell, viewModel: DigitalLineItemViewModel) {
        
        guard let invoice = invoice else { return }
        
        switch invoice.lineItems[viewModel.index].selectedState {
        
        case .selected:
            
            guard let returnReasons = self.invoice?.returnReasons else {
                self.invoice?.lineItems[viewModel.index].selectedState = .deselected(reason: nil)
                return
            }
            
            presentReturnReasonActionSheet(for: viewModel.index,
                                           source: cell.modeSwitch,
                                           with: returnReasons)
            
        case .deselected:
            self.invoice?.lineItems[viewModel.index].selectedState = .selected
        }
    }
        
    func editTapped(cell: DigitalLineItemTableViewCell, viewModel: DigitalLineItemViewModel) {
                
        let viewController = LineItemDetailsViewController()
        viewController.lineItem = invoice?.lineItems[viewModel.index]
        viewController.returnReasons = invoice?.returnReasons
        viewController.lineItemIndex = viewModel.index
        viewController.returnAssistantConfiguration = returnAssistantConfiguration
        viewController.delegate = self
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension DigitalInvoiceViewController {
    
    private func presentReturnReasonActionSheet(for index: Int, source: UIView, with returnReasons: [ReturnReason]) {
        
        DeselectLineItemActionSheet().present(from: self, source: source, returnReasons: returnReasons) { selectedState in
            
            switch selectedState {
            case .selected:
                self.invoice?.lineItems[index].selectedState = .selected
            case .deselected(let reason):
                self.invoice?.lineItems[index].selectedState = .deselected(reason: reason)
            }
        }
    }
}

extension DigitalInvoiceViewController: LineItemDetailsViewControllerDelegate {
    func didSaveLineItem(lineItemDetailsViewController: LineItemDetailsViewController, lineItem: DigitalInvoice.LineItem, index: Int, shouldPopViewController: Bool) {
        
        if shouldPopViewController {
            navigationController?.popViewController(animated: true)
        }
        
        invoice?.lineItems[index] = lineItem
    }
}
