//
//  UserDAO.swift
//  SixtySixDays
//
//  Created by Matheus Godinho on 7/21/15.
//  Copyright (c) 2015 SixtySixDays. All rights reserved.
//

import UIKit

class UserDAO: NSObject {
    
    var dataBase : FMDatabase?
    static private var instance: UserDAO?
    
    var currentUser: User!
    
    override init () {
        NSException(name: "Singleton", reason: "Use UserDAO.sharedInstance()", userInfo: nil).raise()
    }
    
    private init(singleton: Bool!) {
        super.init()
        
        var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var pathDB = appDelegate.dbFilePath
        dataBase = FMDatabase(path: pathDB)
    }
    
    static func sharedInstance() -> UserDAO {
        if instance == nil {
            instance = UserDAO(singleton: true)
        }
        return instance!
    }
    
    func insert(user: User){
        self.dataBase?.open()
        
        var success = self.dataBase?.executeUpdate( "INSERT INTO Usuario (nomeUsuario, nomeFoto) VALUES (?,?)", withArgumentsInArray: [user.name,user.photoName])
        
        if(success == false){
            println("Insert Error: \(self.dataBase!.lastErrorMessage)");
            println("Usuário: nome: \(user.name) nomeFoto: \(user.photoName)")
        } else {
            println("Salvou o Usuário: nome: \(user.name) nomeFoto: \(user.photoName)")
        }
        self.dataBase?.close()
    }
    
    func selectUser(){
        self.dataBase?.open()
        
        let result: FMResultSet = self.dataBase!.executeQuery("SELECT * FROM Usuario", withArgumentsInArray: nil)
        
        while(result.next()){
            var userName = result.stringForColumn("nomeUsuario") as String
            var namePhoto = result.stringForColumn("nomeFoto") as String
            
            currentUser = User(name: userName, photoName: namePhoto)
            
        }
        
        self.dataBase?.close()
    }
    
    func deleteUser(){
        self.dataBase?.open()
        
        var success = self.dataBase?.executeUpdate("DELETE * FROM Usuario", withArgumentsInArray: nil)
        
        if success == false {
            println("Insert Error: \(self.dataBase?.lastErrorMessage())")
        }
        else{
            println("Usuario deletado com sucesso")
        }
        
        self.dataBase?.close()
    }
    
}