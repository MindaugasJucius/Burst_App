fileprivate let SearchHistoryCount = 15

class RecentSearchesDataController {
    
    private var searches: [RecentSearch]
    
    var recentSearches: [RecentSearch] {
        get {
            return searches.sorted { $0.date.compare($1.date) == .orderedDescending }
        }
        set {
            searches = newValue
        }
    }
    
    
    private let bundleFileUrl = Bundle.main.url(forResource: "Searches", withExtension: "plist")!
    private let documentsFilePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("Searches.plist")
    
    init() {
        let fileManager = FileManager.default
        let documentsFileURL = NSURL(fileURLWithPath: documentsFilePath) as URL
        guard fileManager.fileExists(atPath: documentsFilePath) else {
            do {
                try fileManager.copyItem(at: bundleFileUrl, to: documentsFileURL)
                searches = RecentSearchesDataController.readSearches(fromURL: documentsFileURL)
            } catch {
                searches = []
            }
            return
        }
        searches = RecentSearchesDataController.readSearches(fromURL: documentsFileURL)
    }

    // MARK: - Private
    
    private func indexOf(search: RecentSearch) -> Int? {
        return recentSearches.index { $0.query == search.query }
    }
    
    private static func readSearches(fromURL url: URL) -> [RecentSearch] {
        let recentSearchesPlist = NSArray(contentsOf: url) as! [PListDictionary]
        return recentSearchesPlist.map(RecentSearch.init)
    }
    
    // MARK: - Public
    
    func append(search: RecentSearch) {
        var newSearchesArray = recentSearches
        let index = newSearchesArray.index { $0.query.lowercased() == search.query.lowercased() }
        if let existingIndex = index {
            newSearchesArray[existingIndex] = search
        } else if newSearchesArray.count >= SearchHistoryCount {
            guard let last = newSearchesArray.last,
             let indexOfOldest = indexOf(search: last) else {
                return
            }
            newSearchesArray[indexOfOldest] = search
        } else {
            newSearchesArray.append(search)
        }

        let documentsFileURL = NSURL(fileURLWithPath: documentsFilePath) as URL
        let newSearches: [PListDictionary] = newSearchesArray.map { $0.dictionary() }
        (newSearches as NSArray).write(to: documentsFileURL, atomically: true)
        recentSearches = newSearchesArray
    }
    
}
