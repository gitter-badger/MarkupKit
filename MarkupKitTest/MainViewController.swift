//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import UIKit
import MarkupKit

class MainViewController: UIViewController {
    @IBOutlet var greetingLabel: UILabel!
    @IBOutlet var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        LMViewBuilder.view(withName: "MainViewController", owner: self, root: view)
    }

    @IBAction func handleButtonTouchUpInside(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Greeting", message: "Hello!", preferredStyle: .alert)

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel) {(action) in
            print("User tapped Cancel")
        })

        alertController.addAction(UIAlertAction(title: "OK", style: .default) {(action) in
            print("User tapped OK")
        })

        present(alertController, animated: true, completion: nil)
    }

    @IBAction func handleSwitchValueChanged(_ sender: UISwitch) {
        imageView.isHidden = !sender.isOn
    }

    func alertView(_ alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        print("The user clicked button \(buttonIndex)")
    }
}
