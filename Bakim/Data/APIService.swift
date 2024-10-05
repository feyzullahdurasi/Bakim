import Foundation

class APIService {
    func fetchServices(completion: @escaping ([ServiceEntity]?) -> Void) {
        guard let url = URL(string: "https://raw.githubusercontent.com/atilsamancioglu/BTK20-JSONVeriSeti/master/besinler.json") else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            do {
                // JSON verilerini ServiceEntity modeline çevir
                let services = try JSONDecoder().decode([ServiceEntity].self, from: data)
                completion(services)
            } catch {
                completion(nil)
            }
        }
        
        task.resume()
    }
    enum APIError: Error {
        case invalidURL
        case invalidResponse(statusCode: Int)
        case decodingError(Error)
        case networkError(Error)
        
        var userErrorMessage: String {
            switch self {
            case .invalidURL:
                return "Geçersiz bir URL ile karşılaşıldı. Lütfen URL'yi kontrol edin."
            case .invalidResponse(let statusCode):
                return "Sunucu yanıtında bir hata oluştu. Durum kodu: \(statusCode)."
            case .decodingError:
                return "Veri işlenirken bir hata oluştu."
            case .networkError:
                return "Ağ bağlantısı sırasında bir hata oluştu."
            }
        }
    }
}
