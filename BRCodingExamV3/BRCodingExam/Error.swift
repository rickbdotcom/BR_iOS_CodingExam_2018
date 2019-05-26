//
//
//
//
//  Created by rickb on 10/13/18.
//  Copyright © 2018 rickbdotcom LLC All rights reserved.
//

import Foundation
import PromiseKit

extension Promise {
	
	@discardableResult public func alertErrorHandler(_ viewController: UIViewController?) -> PMKFinalizer {
		return self.catch { [weak viewController] error in
			UIAlertController.alertIfError(error)?.ok().show(viewController)
		}
	}
}

extension UIAlertController {
	
	public static func alertIfError(_ error: Error?) -> UIAlertController? {
        guard let error = error else { return nil }
		return UIAlertController.alert(title: error.localizedDescription)
	}
}
