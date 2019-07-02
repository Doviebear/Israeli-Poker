/// Copyright (c) 2018 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import Foundation
import AWSMobileClient
import AWSPinpoint

class AnalyticsManager {
    
    static let shared = AnalyticsManager()
    private var pinpoint: AWSPinpoint?
    
    private init() { }
    
    func setupClient(withLaunchOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        pinpoint = AWSPinpoint(configuration:
            AWSPinpointConfiguration.defaultPinpointConfiguration(launchOptions: launchOptions))
    }
    
    func create(event: String, attributes: [String: String]? = nil, metrics: [String: NSNumber]? = nil) {
        guard let pinpoint = pinpoint else { return }
        
        let event = pinpoint.analyticsClient.createEvent(withEventType: event)
        
        // 1
        if let eventAttributes = attributes {
            for (key, attributeValue) in eventAttributes {
                event.addAttribute(attributeValue, forKey: key)
            }
        }
        
        // 2
        if let eventMetrics = metrics {
            for (key, metricValue) in eventMetrics {
                event.addMetric(metricValue, forKey: key)
            }
        }
        pinpoint.analyticsClient.record(event)
    }
    func uploadEvents() {
        guard let pinpoint = pinpoint else { return }
        pinpoint.analyticsClient.submitEvents()
    }
}
