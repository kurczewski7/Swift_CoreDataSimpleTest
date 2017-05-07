//
//  TestViewController.swift
//  DatabaseTest
//
//  Created by Slawek Kurczewski on 06.05.2017.
//  Copyright © 2017 Slawomir Kurczewski. All rights reserved.
//

import UIKit
import CoreData

var pos: Int=0
var ver:Int=1
class TestViewController: UIViewController {
    var filmbase = [Filmbase]()
    
    let obrazki: [String] = ["barrafina","bourkestreetbakery","cafedeadend"]
    let tytuly: [String] = ["aaaaaa","bbbbbbbb","cccccccc"]
    let managedObjectContext: NSManagedObjectContext! = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    @IBOutlet var obrazekImage: UIImageView! {
        didSet {
         obrazekImage.image=UIImage(named: obrazki[1])
        }
    }
    
    @IBOutlet var etykietaLabel: UILabel!
    @IBOutlet var etykietaLabel2: UILabel!
    @IBOutlet var klawiszButtopn: UIButton!
    
    @IBAction func kliknietoKlawisz(_ sender: Any) {
        pos += 1
        if pos > tytuly.count-1{
          pos=0
        }
        etykietaLabel.text = filmbase[pos].nazwa
        etykietaLabel2.text = filmbase[pos].tytul
        
        if let imageData = filmbase[pos].obraz {
            if let imageTmp = UIImage(data: imageData as Data){
                obrazekImage.image = imageTmp
            }        
        }
                
    }

    @IBAction func policzButton(_ sender: Any) {
        print("Liczba rekordów w bazie:\(filmbase.count)")
        let el = Filmbase.accessibilityElementCount()
        print("Dostępnych rekordów w bazie:\(el)")
    }
    
    @IBAction func kasujButton(_ sender: Any) {
        //filmbase.removeAll(keepingCapacity: false)
        
        let fetchRequest=NSFetchRequest<Filmbase>(entityName: "Filmbase")
        let deleteRequest=NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        do { try managedObjectContext.execute(deleteRequest) }
        catch { print("Błąd kasaowania \(error.localizedDescription)")}
    }
    
    @IBAction func saveButton(_ sender: Any) {
        //let presentItem=Filmbase(context: managedObjectContext)
        do {
            try self.managedObjectContext.save()
        } catch{
            print("Nie mogę zapisać danych \(error.localizedDescription)")
        }

    }

    @IBAction func addDataButton(_ sender: Any) {
                    for i in 0..<obrazki.count
                    {
                        print("i=\(i),\(obrazki[i])")
                        createPresentItem(imageName: obrazki[i], title: "\(tytuly[i]):\(ver)")
                    }

    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        LoadData()
        print("Liczba rekordów w bazie:\(filmbase.count)")
        if filmbase.count==0 {
//            for i in 0..<obrazki.count
//            {
//                print("i=\(i),\(obrazki[i])")
//                createPresentItem(imageName: obrazki[i], title: tytuly[i])
//            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }
    
    func createPresentItem(imageName:String,  title: String){
        
        let presentItem = Filmbase(context: managedObjectContext)
        let image = UIImage(named: imageName)
        let imgData = UIImageJPEGRepresentation(image!, 1)
        
        //presentItem.obrazek = data
        presentItem.tytul = title
        presentItem.nazwa=imageName
        presentItem.obraz = imgData! as NSData
        
        do {
            try self.managedObjectContext.save()
        }catch {
            print("Nie mogę zapisać danych \(error.localizedDescription)")
        }
    }
    func LoadData(){
        let presentRequest: NSFetchRequest<Filmbase> = Filmbase.fetchRequest()
        
        do {
            filmbase = try managedObjectContext.fetch(presentRequest)
        } catch {
            
            print("Nie można załadować danych \(error.localizedDescription)")
        }
        
        // presentRequest.sortDescriptors
    }
}
