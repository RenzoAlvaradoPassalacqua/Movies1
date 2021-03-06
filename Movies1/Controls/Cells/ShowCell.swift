//
//  ShowCell.swift
//  AppleCoding OAuth
//
//  Modified by Renzo Alvarado
//  
//


import UIKit
import Foundation

import CoreTraktTV

internal class ShowCell: UICollectionViewCell
{
    internal enum Status
    {
        case add
        case added
        case error
    }
    
    ///
    @IBOutlet private weak var imageCover: UIImageView!
    ///
    @IBOutlet private weak var labelTitle: UILabel!
    ///
    @IBOutlet private weak var buttonAction: UIButton!
    
    ///
    internal weak var delegate: ShowCellDelegate?

    ///
    internal var showInformation: Movie?
    {
        didSet
        {
            self.presentShowInformation()
        }
    }
    
    /**
     
    */
    override internal func awakeFromNib() -> Void
    {
        super.awakeFromNib()

        self.applyTheme()
    }
    
    /**
     
     */
    override internal func prepareForReuse() -> Void
    {
        super.prepareForReuse()
        
        self.imageCover.image = UIImage(named: "ShowCover")
        
        self.labelTitle.text = ""
    }

    //
    // MARK: - Prepare UI
    //

    private func applyTheme() -> Void
    {
        self.backgroundColor = Theme.current.secondaryBackgroundColor
        self.labelTitle.textColor = Theme.current.textColor
        
        self.buttonAction.backgroundColor = Theme.current.tintColor
        self.buttonAction.tintColor = UIColor.white
        self.buttonAction.layer.cornerRadius = 4.0
        self.buttonAction.layer.masksToBounds = true
    }
    
    private func applyAddTheme() -> Void
    {
        self.buttonAction.backgroundColor = Theme.current.tintColor
        self.buttonAction.tintColor = UIColor.white
        self.buttonAction.setTitle("ADD", for: .normal)
    }
    
    public func applyAddedTheme() -> Void
    {
        self.buttonAction.backgroundColor = Theme.Tint.green.uiColor
        self.buttonAction.tintColor = UIColor.white
        self.buttonAction.setTitle("ADDED", for: .normal)
    }
    
    public func applyErrorTheme() -> Void
    {
        self.buttonAction.backgroundColor = Theme.Tint.red.uiColor
        self.buttonAction.tintColor = UIColor.white
        self.buttonAction.setTitle("ERROR", for: .normal)
    }

    //
    // MARK: - Data
    //
    
    /**
     
    */
    internal func presentShowInformation() -> Void
    {
        guard let movie = self.showInformation else
        {
            return 
        }
        
        let loadQueue = DispatchQueue(label: "com.desappstre.OAuth./show", attributes: .concurrent)
        
        print("movie title ", movie.title)
       // print("\(movie.titleM). \(movie.identifiers.trakt)")
      
      /*  loadQueue.async
        {
        if let cover = UIImage(named: "\(movie.identifiers.trakt)")
        {
            DispatchQueue.main.async
            {
                self.imageCover.image = cover
            }
        }
        }
 */
        self.labelTitle.text = movie.title?.uppercased()
    }
    
    internal func toogleButton(toStatus status: Status) -> Void
    {
        switch status
        {
            case .add:
                self.applyAddTheme()
            case .added:
                self.applyAddedTheme()
            case .error:
                self.applyErrorTheme()
        }
    }
    
    //
    // MARK: - Actions
    //
    
    /**
     
     */
    @IBAction private func handleActionButtonTap(sender: UIButton) -> Void
    {
        guard let movie = self.showInformation else
        {
            return 
        }

        //self.delegate?.showCell(self, didSelectShow: movie.identifiers.trakt)
    }
}
