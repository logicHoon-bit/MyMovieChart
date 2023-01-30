//
//  ListViewController.swift
//  MyMovieChart
//
//  Created by 이치훈 on 2023/01/17.
//

import UIKit

struct Hoppin: Codable{
    let totalCount: Int?
    let movies: [Movie]
    
    enum CodingKeys: String, CodingKey {
            case totalCount
            case movies = "movies"
        }
}
struct Movie: Codable{
    let title: String?
    let description: String?
    let thumbnail: String?
    let detail: String?
    let rating: Double?
    
    enum CodingKeys: String, CodingKey {
        case title
        case description = "description"
        case thumbnail = "thumbnail"
        case detail = "detail"
        case rating = "rating"
    }
}

class ListViewController: UITableViewController {
    
    override func viewDidLoad() {
        getData()
//        let url = "http://swiftapi.rubypaper.co.kr:2029/hoppin/movies?version=1&page=1&count=10&genreId=&order=releasedateasc"
//
//        let apiURI: URL! = URL(string: url)
//
//        let apidata = try! Data(contentsOf: apiURI)
//
//        let log = NSString(data: apidata, encoding: String.Encoding.utf8.rawValue) ?? "데이터가 없습니다"
//        NSLog("*************API Result = \(log)")
//
//        do{
//            let apiDictionaly = try JSONSerialization.jsonObject(with: apidata, options: []) as! NSDictionary
//
//            let hoppin = apiDictionaly["hoppin"] as! NSDictionary
//            let movies = hoppin["movies"] as! NSDictionary
//            let movie = movies["movie"] as! NSArray
//
//            for row in movie{
//                let r = row as! NSDictionary
//
//                let mvo = MovieVO()
//
//                mvo.title = r["title"] as? String
//                mvo.description = r["genreNames"] as? String
//                mvo.thumbnail = r["thumbnailImage"] as? String
//                mvo.detail = r["linkUrl"] as? String
//                //mvo.rating = ((r["ratingAverage"] as! NSString).doubleValue)
//
//                self.list.append(mvo)
//            }
//        }catch{}
    }
    
    func getData(){
        guard let url = URL(string: "http://swiftapi.rubypaper.co.kr:2029/hoppin/movies?version=1&page=1&count=10&genreId=&order=releasedateasc") else {return}
        let session = URLSession(configuration: .default)
            
        session.dataTask(with: url) { data, reponse, error in
            if error != nil{
                print(error!)
                return
            }
            guard let data = data, error == nil else {
                print("데이터 오류!!")
                return}
            
            let decoder = JSONDecoder()
            guard let hoppin = try? decoder.decode(Hoppin.self, from: data) else {
                print("디코딩 오류!!")
                return}
            DispatchQueue.main.async {
                let log = String(data: data, encoding: .utf8)
                NSLog("*************API Result = \(log!)")
                print(hoppin.movies)
            }
            
//            let respons =  try decoder.decode(Hoppin.self, from: data)
//            print("load success")
//            let searchMovie = respons.movies
        }.resume()
        
    }
    
    var page = 1
    var dataset = [
    ("다크나이트", "영웅물에 철학에 음악까지 더해져 예술이 되다.", "2008-09-04", "8.95", "darknight.jpg"),
    ("호우시절", "때를 알고 내리는 좋은 비", "2008-09-04", "7.31", "rain.jpg"),
    ("말할 수 없는 비밀", "여기서 너까지 다섯 걸음", "2015-05-07", "9.19", "secret.jpg")
    ]
    
    lazy var list: [MovieVO] = {
        
        var datalist = [MovieVO]()
        for (title, desc, opendate, rating, thumbnail) in self.dataset{
            let mvo = MovieVO()
            mvo.title = title
            mvo.description = desc
            mvo.opendate = opendate
            mvo.rating = rating
            mvo.thumbnail = thumbnail
            
            datalist.append(mvo)
        }
        return datalist
    }()
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = self.list[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell") as! MovieCell
        //return cell instance
        
        cell.title.text = row.title
        cell.desc.text = row.description
        cell.opendate.text = row.opendate
        cell.rating.text = "\(row.rating!)"
        cell.thumbnail.image = UIImage(named: row.thumbnail!)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let uvc = self.storyboard?.instantiateViewController(withIdentifier: "movieinfo") else {return}
        self.navigationController?.pushViewController(uvc, animated: true)
    }
    
    @IBAction func more(_ sender: Any) {
    }
    
}
