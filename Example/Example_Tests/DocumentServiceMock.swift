//
//  DocumentServiceMock.swift
//  Example Swift
//
//  Created by Enrique del Pozo Gómez on 6/5/18.
//  Copyright © 2018 Gini GmbH. All rights reserved.
//

import Foundation
@testable import GiniPayApiLib
@testable import GiniCapture
@testable import Example_Swift

final class DocumentServiceMock: ComponentAPIDocumentServiceProtocol {

    var apiLib: GiniApiLib
    var document: Document?
    var analysisCancellationToken: CancellationToken?
    
    init(lib: GiniApiLib, documentMetadata: Document.Metadata?) {
        self.apiLib = lib
    }
    
    func cancelAnalysis() {
        
    }
    
    func remove(document: GiniCaptureDocument) {
        
    }
    
    func resetToInitialState() {
        
    }
    
    func sendFeedback(with updatedExtractions: [Extraction]) {
        
    }
    
    func startAnalysis(completion: @escaping ComponentAPIAnalysisCompletion) {
        
    }
    
    func sortDocuments(withSameOrderAs documents: [GiniCaptureDocument]) {
        
    }
    
    func upload(document: GiniCaptureDocument, completion: ComponentAPIUploadDocumentCompletion?) {
        
    }
    
    func update(imageDocument: GiniImageDocument) {
        
    }

}

extension DocumentServiceMock {
    convenience init() {
        self.init(lib: GiniApiLib.Builder(client: Client(id: "id", secret: "secret", domain: "domain")).build(),
                  documentMetadata: nil)
    }
}
