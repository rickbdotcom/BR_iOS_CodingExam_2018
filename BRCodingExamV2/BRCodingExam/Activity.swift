//
//
//
//
//  Created by rickb on 10/13/18.
//  Copyright © 2018 rickbdotcom LLC All rights reserved.
//

import UIKit
import PromiseKit

public protocol Activity {
	func startActivity(context: Any?)
	func stopActivity(context: Any?)
}

public extension Promise {

	func show(activity: Activity?, context: Any? = nil) -> Promise {
		activity?.startActivity(context: context)
		
		return ensure {
			activity?.stopActivity(context: context)
		}
	}
}

public extension Guarantee {

	func show(activity: Activity?, context: Any? = nil) -> Guarantee {
		activity?.startActivity(context: context)
		
		return get { _ in
			activity?.stopActivity(context: context)
		}
	}
}
