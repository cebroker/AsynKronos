//
//  Async.swift
//  AsynKronos
//
//  Created by Luis David Goyes Garces on 7/10/19.
//  Copyright © 2019 Condor Labs S.A.S. All rights reserved.
//

class Async {
    class func await(
        _ closure: @escaping () -> ()) {
        
        DispatchQueue.global(qos: .userInitiated).sync {
            closure()
        }
    }
    
    class func await(
        _ closure: @escaping () throws -> (),
        onError: (Error) -> (),
        doFinally: @escaping () -> () = { }) {
        
        DispatchQueue.global(qos: .userInitiated).sync {
            
            do {
                try closure()
            } catch {
                onError(error)
            }
            
            DispatchQueue.main.async {
                doFinally()
            }
        }
    }
}
