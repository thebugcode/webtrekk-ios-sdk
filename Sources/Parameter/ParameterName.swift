internal enum ParameterName: String {
	// MARK: Pixel
	case Pixel = "p"

	// MARK: General
	case EverId          = "eid"
	case FirstStart      = "one"
	case IpAddress       = "X-WT-IP"
	case NationalCode    = "la"
	case SamplingRate    = "ps"
	case TimeStamp       = "mts"
	case TimeZoneOffset  = "tz"
	case UserAgent       = "X-WT-UA"

	// MARK: Page
	case Page          = "cp"
	case PageCategory  = "cg"
	case Session       = "cs"

	// MARK: Action
	case ActionCategory = "ck"
	case ActionName     = "ct"

	// MARK: E-Commerce
	case EcomCategory     = "cb"
	case EcomVoucherValue = "cb563"
	case EcomCurrency     = "cr"
	case EcomOrderNumber  = "oi"
	case EcomTotalValue   = "ov"
	case EcomStatus       = "st"

	// MARK: Product
	case ProductCategory = "ca"
	case ProductName     = "ba"
	case ProductPrice    = "co"
	case ProductQuantity = "qn"

	// MARK: Customer
	case CustomerBirthday      = "uc707"
	case CustomerCategory      = "uc"
	case CustomerCity          = "uc708"
	case CustomerCountry       = "uc709"
	case CustomerEmail         = "uc700"
	case CustomerEmailReciever = "uc701"
	case CustomerFirstName     = "uc703"
	case CustomerGender        = "uc706"
	case CustomerLastName      = "uc704"
	case CustomerNewsletter    = "uc702"
	case CustomerNumber        = "cd"
	case CustomerPhoneNumber   = "uc705"
	case CustomerStreet        = "uc711"
	case CustomerStreetNumber  = "uc712"
	case CustomerZip           = "uc710"

	// MARK: Media
	case MediaBandwidth       = "bw"
	case MediaCategory        = "mg"
	case MediaCurrentPosition = "mt1"
	case MediaDescription     = "mi"
	case MediaEvent           = "mk"
	case MediaMute            = "mut"
	case MediaPosition        = "pos"
	case MediaTotalDuration   = "mt2"
	case MediaVolumn          = "vol"

}