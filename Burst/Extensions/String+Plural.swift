fileprivate let PluralCount = 1
fileprivate let PluralEnding: Character = "s"

extension String {
    
    mutating func modifiedPlural(forCount count: Int) -> String {
        guard let character = self.characters.last else {
            return self
        }
        if count > PluralCount {
            if character != PluralEnding {
                self.characters.append(PluralEnding)
            }
        } else {
            if character == PluralEnding {
                self.remove(at: self.index(before: self.endIndex))
            }
        }
        return self
    }
}
