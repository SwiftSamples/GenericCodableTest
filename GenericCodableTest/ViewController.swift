
import UIKit
import SDWebImage

var keyWindow : UIWindow?


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var movieData: UpcomingMovie? {
        didSet {
            DispatchQueue.main.async{
                self.tableView.reloadData()
            }
        }
    }
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TestServicecall()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieData?.results?.count ?? 0 //5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as! MovieTableViewCell
        let indexPathData = movieData?.results?[indexPath.row]
        // cell.movieImg.sd_setImage(with: URL(string: indexPathData.), placeholderImage: UIImage(named: ""))
        cell.nameLbl.text = indexPathData?.title
        cell.selectionStyle = .none
        return cell
    }
    
    func TestServicecall(){
        
        APIReqeustManager.sharedInstance.serviceCall(param: nil, method: .post, model: UpcomingMovie.self, loaderNeed: true, vc: self, url: "https://api.themoviedb.org/3/movie/upcoming?api_key=f6076cf84161dd874113336b6cf83702", isTokenNeeded: false, isErrorAlertNeeded: true, actionErrorOrSuccess: nil){ [weak self] (resp) in
            
            //  movieData = resp
            
            //            let decoder = JSONDecoder()
            //            if let jsonData = try? decoder.decode(UpcomingMovie.self, from: resp.data ?? Data()) {
            //                self?.movieData = jsonData
            //            }
        }
    }
}



class MovieTableViewCell: UITableViewCell {
    
    @IBOutlet weak var movieImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}







