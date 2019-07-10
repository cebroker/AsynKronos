//
//  Async.swift
//  AsynKronos
//
//  Created by Luis David Goyes Garces on 7/10/19.
//  Copyright © 2019 Condor Labs S.A.S. All rights reserved.
//

public class Async {
    public class func await(
        _ closure: @escaping () -> ()) {
        
        DispatchQueue.global(qos: .userInitiated).sync {
            closure()
        }
    }
    
    public class func await(
        _ closure: @escaping () throws -> (),
        onError: @escaping (Error) -> (),
        doFinally: @escaping () -> () = { }) {
        
        DispatchQueue.global(qos: .userInitiated).sync {
            
            do {
                try closure()
            } catch {
                DispatchQueue.main.async {
                    onError(error)
                }
            }
            
            DispatchQueue.main.async {
                doFinally()
            }
        }
    }
}
