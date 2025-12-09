//
//  SurveyParameters+Builder.swift
//  alium_sdk
//
//  Created by yusera-ansari on 09/12/25.
//

public extension SurveyParameters{
    class Builder{
        private var screenName:String
        private var customerVariables:[String:String]=[:]
        public init(screen : String){
            self.screenName = screen;
        }
        @discardableResult
              public func addDim(_ number: Int, value: String?) -> Builder {
                  guard let value else{
                      return self
                  }
                  customerVariables["dim\(number)"] = value
                  return self
              }

              @discardableResult
              public func addCustom(key: String, value: String?) -> Builder {
                  guard let value else{
                      return self
                  }
                  customerVariables[key] = value
                  return self
              }

             
              private func clean() {
                  customerVariables = customerVariables.filter {
                      let v = $0.value
                      guard  !v.isEmpty, v.count != 0 else { return false }
                      return !v.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                  }
              }

              public func build() -> SurveyParameters {
                  clean()
                  return SurveyParameters(
                      screenName: screenName,
                      customerVariables: customerVariables
                  )
              }
    }
}
