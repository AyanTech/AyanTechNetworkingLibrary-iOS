import Foundation

struct ATResponseEnvelope<Parameters: Decodable>: Decodable {
    let status: ATStatusV2?
    let parameters: Parameters?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        status = try container.decodeIfPresent(ATStatusV2.self, forKey: .status)

        do {
            parameters = try container.decode(Parameters.self, forKey: .parameters)
        } catch {
            parameters = nil
        }
    }

    private enum CodingKeys: String, CodingKey {
        case status = "Status"
        case parameters = "Parameters"
    }
}
