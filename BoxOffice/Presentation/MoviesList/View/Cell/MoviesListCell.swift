import UIKit

final class MoviesListCell: UICollectionViewListCell {
    private let rankStackView = UIStackView().makeStackView(axis: .vertical, alignment: .center, spacing: 4)
    private let titleAndAudienceStackView = UIStackView().makeStackView(axis: .vertical, alignment: .fill, spacing: 4)
    private let titleLabel = UILabel().makeCellLabel(fontSize: 15, textColor: .black)
    private let rankLabel = UILabel().makeCellLabel(fontSize: 25, textColor: .black)
    private let changeLabel = UILabel().makeCellLabel(fontSize: 13, textColor: .red)
    private let audienceLabel = UILabel().makeCellLabel(fontSize: 14, textColor: .gray)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
        rankLabel.text = ""
        changeLabel.text = ""
        changeLabel.textColor = .white
        audienceLabel.text = ""
    }
}

extension MoviesListCell {
    private func setupViews() {
        addSubview(rankStackView)
        rankStackView.addArrangedSubview(rankLabel)
        rankStackView.addArrangedSubview(changeLabel)
        
        addSubview(titleAndAudienceStackView)
        titleAndAudienceStackView.addArrangedSubview(titleLabel)
        titleAndAudienceStackView.addArrangedSubview(audienceLabel)
        
        rankStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            rankStackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            rankStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 35)
        ])
        
        titleAndAudienceStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleAndAudienceStackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            titleAndAudienceStackView.leadingAnchor.constraint(equalTo: rankStackView.leadingAnchor, constant: 50)
        ])
    }
    
    func configure(_ movie: MovieBoxOffice) {
        titleLabel.text = {
            var text = movie.movieName
            if text.count > 20 {
                let index = text.index(text.startIndex, offsetBy: 20)
                text = String(text[..<index]) + "..."
                return text
            }
            return text
        }()
        rankLabel.text = {
            return "\(movie.rank)"
        }()
        changeLabel.text = {
            if movie.rankChangesWithPreviousDay > 0 {
                return "▲\(movie.rankChangesWithPreviousDay)"
            }
            if movie.rankChangesWithPreviousDay < 0 {
                return "▼\(abs(movie.rankChangesWithPreviousDay))"
            }
            if movie.rankOldAndNew == .new {
                return "신작"
            }
            return "-"
        }()
        changeLabel.textColor = {
            if movie.rankOldAndNew == .new {
                return .red
            }
            if movie.rankChangesWithPreviousDay > 0 {
                return .red
            }
            if movie.rankChangesWithPreviousDay < 0 {
                return .blue
            }
            return .gray
        }()
        audienceLabel.text = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            let formattedAudienceCount = formatter.string(from: NSNumber(value: movie.audienceCount)) ?? "\(movie.audienceCount)"
            let formattedAccumulation = formatter.string(from: NSNumber(value: movie.audienceAccumulation)) ?? "\(movie.audienceAccumulation)"
            return "오늘 \(formattedAudienceCount) / 총 \(formattedAccumulation)"
        }()
        selectedBackgroundView = UIView()
        selectedBackgroundView?.backgroundColor = .clear
        accessories = [.disclosureIndicator()]
    }
}
