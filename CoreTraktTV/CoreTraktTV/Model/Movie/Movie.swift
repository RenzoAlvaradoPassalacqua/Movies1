public final class Movie: StandardMediaEntity {
  public let year: Int?
  public let ids: MovieIds
  public let titleM: String?
    
	private enum CodingKeys: String, CodingKey {
		case year, ids, titleM
	}

	public required init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)

		self.year = try container.decodeIfPresent(Int.self, forKey: .year)
		self.ids = try container.decode(MovieIds.self, forKey: .ids)
		
		self.titleM = try container.decodeIfPresent(String.self, forKey: .titleM)
		
		try super.init(from: decoder)
	}

  public override var hashValue: Int {
    var hash = super.hashValue ^ ids.hashValue

	if let yearHash = year?.hashValue {
		hash = hash ^ yearHash
	}

    return hash
  }
}
