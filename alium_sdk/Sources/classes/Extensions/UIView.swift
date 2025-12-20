//
//  UiViewController+Extension.swift
//  Pods
//
//  Created by yusera-ansari on 18/12/25.
//

extension UIView{
    func removeAutoResizingMask(){
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    func activateConstraints(_ constraints : [NSLayoutConstraint]){
        removeAutoResizingMask()
        NSLayoutConstraint.activate(constraints);
    }
    func pin(to parent : UIView){
        activateConstraints([
            self.topAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.topAnchor),
            self.bottomAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.bottomAnchor),
            self.leadingAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.trailingAnchor),
            
        ])
    }
    func pin(toMarginOf superView:UIView ){
          removeAutoResizingMask()
          NSLayoutConstraint.activate([
              self.leadingAnchor.constraint(equalTo: superView.layoutMarginsGuide.leadingAnchor)
              ,
              self.trailingAnchor.constraint(equalTo: superView.layoutMarginsGuide.trailingAnchor),
              self.topAnchor.constraint(equalTo: superView.layoutMarginsGuide.topAnchor),
              self.bottomAnchor.constraint(equalTo: superView.layoutMarginsGuide.bottomAnchor)
          ])
      }
    func pin(to parent: UIView, constant: CGFloat = 0) {
        activateConstraints([
            topAnchor.constraint(equalTo: parent.topAnchor, constant: constant),
            bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: -constant),
            leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: constant),
            trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: -constant)
        ])
    }
    func emptyView(){
        self.subviews.forEach { ele in
            ele.removeFromSuperview()
        }
    }
}
