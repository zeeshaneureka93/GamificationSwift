//
//  Keys.swift
//  CoreDirection
//
//  Created by Ahmar on 8/18/17.
//  Copyright © 2017 Rebel Technology. All rights reserved.
//

import Foundation
import UIKit

// These are all the keys from server response ditionaries
struct Key {
    
    // MARK: - Response Modal
    struct Response {
        static let meta = "meta"
        static let data = "data"
        static let error = "error"
        static let code = "code"
        static let status = "status"
        
        // Gamification
        static let success = "success"
        static let message = "message"
        static let title = "title"
        static let cmd = "cmd"
        static let alert = "alert"
        static let info = "info"

    }
    
    // MARK: - Session Modal
    struct Session    {
        static let authToken = "authToken"
        static let user = "user"
        static let keepLogin = "keepLogin"
        
    }

    // MARK: - Request Modal
    struct Request {
        static let currentPassword = "oldPassword"
        static let newPassword = "newPassword"
        static let usernameOrEmail = "usernameOrEmail"
        static let password = "password"
        static let interval = "interval"
        static let membershipNumber = "membershipNumber"
        static let classId = "classId"
        static let isPeriodExpired = "isPeriodExpired"
        static let workoutId = "workoutId"
        
        static let username = "username"
        static let email = "email"
        static let departmentId = "departmentId"
        static let corporateID = "corporateId"
        static let membershipNumberID = "membershipNumberId"
        static let phone = "phone"
        static let companyKey = "companyKey"
        static let keyID = "key_id"

        struct GamificationActions {
            static let type = "action_id"
            static let pointsToOveride = "points"
            static let id = "info_id"
            
        }
    }

    // MARK: - User Modal
    struct User {
        static let userId = "userId"
        static let userIdCaps = "UserId"
        static let authToken = "authToken"
        static let userAuthorization = "AuthorizationUserToken"
        static let authorization = "Authorization"
        static let encryption = "Encryption"
        static let compression = "Compression"

        static let deviceType = "DeviceType"
        static let deviceToken = "DeviceToken"        
        static let lang = "lang"
        
        static let firstName = "firstName"
        static let lastName = "lastName"
        static let gender = "gender"
        static let dateOfBirth = "dateOfBirth"
        static let image = "image"
        static let email = "email"
        static let phone = "phone"

        static let id = "id"
        static let imageUrl = "imageUrl"
        static let joiningDate = "joiningDate"

        enum KeyType: String {
            case DiscountOnly="Discount"
            case PreloadedPackage="Package"
            case CorePass="CorePass"
            case Profile="Profile"
        }
        
        // MARK: - User Profile Modal
        struct Profile {
            static let id = "id"
            static let title = "title"
            static let code = "code"
            static let value = "value"
            static let iconUrl = "iconUrl"
            static let minValue = "min_value"
            static let maxValue = "max_value"
            static let unit = "unit"
            static let lastUpdated = "lastUpdated"
            static let status = "status"
            static let points = "points"
            static let detail = "detail"
            
            // MARK: - User Objectives Modal
            struct Objectives    {
                static let id = "id"
                static let title = "title"
                static let code = "code"
                static let status = "status"
                static let iconUrl = "iconUrl"
            }
            
            // MARK: - User Goals Modal
            struct Goals    {
                static let date = "date"
                static let measurements = "measurements"
            }
            
            // MARK: - User Steps Modal
            struct Steps    {
                static let id = "id"
                static let title = "title"
                static let code = "code"
                static let status = "status"
                static let points = "points"
                static let iconUrl = "iconUrl"
                static let lastUpdated = "lastUpdated"
                static let message = "message"
                static let detail = "detail"
            }

        }

    }
    
    // MARK: - Articles Modal
    struct Article {
        static let id = "id"
        static let articleId = "articleId"
        static let isRecommended = "isRecommended"
        static let page = "page"

        static let title = "title"
        static let imageUrl = "imageUrl"
        static let isFavorite = "isFavorite"
        static let lastUpdated = "lastUpdated"
        
        static let content = "content"
        static let author = "author"
        static let publishDate = "publishDate"
        
        static let code = "code"
        static let tagCount = "tagCount"


    }

    // MARK: - Article List Modal
    struct ArticleList {
        static let totalRecords = "totalRecords"
        static let list = "list"
    }

    
    // MARK: - Activity Modal
    struct Activity {
        static let id = "id"
        static let articleId = "activityId"
        static let isRecommended = "isRecommended"
        static let page = "page"
        
        static let activityType = "activityType"
        static let name = "name"
        static let imageUrl = "imageUrl"
        static let code = "code"
        
        static let classId = "classId"
        static let isFavorite = "isFavorite"
        static let gymInfo = "gymInfo"
        
        // MARK: - Amenity Modal
        struct Amenity {
            static let name = "name"
            static let code = "code"
        }

        
        // MARK: - Class Packages Modal
        struct ClassPackages  {
            static let classId = "classId"
            static let facilityId = "facilityId"
            static let show = "show"
            static let date = "date"
            static let packageId = "packageId"
        }
        
        // MARK: - Facility Modal
        struct Facility {
            static let id = "id"
            static let name = "name"
            static let logo = "logo"
            static let recurrence = "recurrence"
            static let activityId = "activityId"
            static let activityName = "activityName"
            static let startDate = "startDate"
            static let endDate = "endDate"
            static let startTime = "startTime"
            static let duration = "duration"
            static let slots = "slots"
            static let activityImage = "activityImage"
            
            static let activityClass = "class"
            static let memberPackage = "memberPackage"
            static let packages = "schedulePackages"
            
            
            // MARK: - Facility Item Details Modal
            struct FacilityDetail {
                static let gymInfo = "gymInfo"
                static let gallery = "gallery"
                static let activities = "activities"
                static let amenities = "amenities"
                static let classes = "classes"
                static let packages = "packages"
                static let Session = "Session"
                static let Membership = "Membership"
            }

        }
        
        // MARK: - Facility Session Modal
        struct FacilitySession    {
            
            static let classId = "classId"
            static let className = "className"
            static let classCode = "classCode"
            static let classLogo = "classLogo"
            static let startDate = "startDate"
            static let endDate = "endDate"
            static let slots = "slots"
            static let duration = "duration"
            static let recurrence = "recurrence"
            
            
            
            static let packageId = "id"
            static let name = "name"
            static let code = "code"
            static let validity = "validity"
            static let price = "price"
            static let discount = "discount"
            static let packageType = "packageType"
            static let isCorepass = "is_corepass"
            static let sessions = "sessions"
        }
        

        
        // MARK: - Facility Item Gallery Modal
        struct FacilityGallery {
            static let sequence = "sequence"
            static let galleryImage = "galleryImage"
            static let lastUpdated = "lastUpdated"
        }

        // MARK: - Membership Package Modal
        struct MembershipPackage {
            static let packageId = "packageId"
            static let packageName = "packageName"
            static let packageType = "packageType"
            static let price = "price"
            static let sessions = "sessions"
            static let validityDays = "validityDays"
            static let expireson = "expireson"
            static let checkin = "checkin"
            static let facilityId = "facilityId"
            static let facilityName = "facilityName"
            static let facilityImage = "facilityImage"
            static let isCorepass = "is_corepass"
            static let lastUpdated = "lastUpdated"
        }
        
        // MARK: - Gym Info Modal
        struct GymInfo {
            static let id = "id"
            static let name = "name"
            static let latitude = "latitude"
            static let longitude = "longitude"
            static let address = "address"
            static let website = "website"
            static let biography = "biography"
            static let facilityId = "id"
            static let facilityImage = "facilityImage"
            static let facilityPhoneNo = "facilityPhoneNo"
        }
        
    }
    
    // MARK: - Activity Amenities Modal
    struct ActivityAmenities {
        static let amenities = "amenities"
        static let activities = "activities"
        static let topActivities = "topActivities"
    }
    
    // MARK: - Activity Recommended Modal
    struct ActivityRecommended {
        static let classId = "classId"
        static let name = "name"
        static let code = "code"
        static let description = "description"
        static let activityImage = "activityImage"
        static let scheduleId = "schedule_detail_id"
        static let duration = "duration"
        static let instructorId = "instructorId"
        static let instructorName = "instructorName"
        static let slots = "slots"
        static let facilityId = "facilityId"
        static let facility = "facility"
        static let city = "address"
        static let facilityImage = "facilityImage"
        static let startDate = "startDate"
        static let endDate = "endDate"
        static let classDate = "classDate"
        static let facilityLatitude = "facilityLatitude"
        static let facilityLongitude = "facilityLongitude"
        static let activityId = "activityId"
        static let recurrence = "recurrence"
        static let isFree = "isFree"
        static let lastUpdated = "lastUpdated"
        static let checkin = "checkin"
        static let visits = "visits"
        static let facilityPhoneNo = "facilityPhoneNo"
    }
    
    
    


    // MARK: - Search Parameters Modal
    struct Search {
        static let keyword = "keyword"
        static let filters = "filters"
        static let categories = "categories"
        static let tags = "tags"
        static let page = "page"
        static let pageSize = "pageSize"
        static let articleId = "articleId"
        static let resetFilter = "resetFilter"
        static let list = "list"
        static let totalRecords = "totalRecords"

        static let latitude = "latitude"
        static let longitude = "longitude"
        
        static let dateFrom = "dateFrom"
        static let date = "date"
        static let session = "session"
        static let distance = "distance"

        static let activities = "activities"
        static let amenities = "amenities"
        
        static let showFree = "show_free"

    }

    
    // MARK: - Wallet Modal
    struct Wallet {
        static let activityId = "activityId"
        static let activityName = "activityName"
        static let activityImage = "activityImage"
        static let activityTypeId = "activityTypeId"
        static let activityTypeCode = "activityTypeCode"
        static let recurrence = "recurrence"
        static let classId = "classId"
        static let validity = "validity"
        static let startDate = "startDate"
        static let endDate = "endDate"
        static let duration = "duration"
        static let facilityName = "facilityName"
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let facilityImage = "facilityImage"
        static let checkin = "checkin"
        static let visits = "visits"
        static let address = "address"
        static let packageName = "packageName"
        static let packageType = "packageType"
        static let price = "price"
        static let isCorepass = "isCorepass"
        static let isFavorite = "isFavorite"
        static let status = "status"
        static let createdDate = "createdDate"
        static let bookedDate = "bookedDate"
        static let scheduleDate = "scheduleDate"
        static let facilityId = "facilityId"
        static let slotId = "slotId"
        static let timezone = "timezone"
        static let isFree = "isFree"
        static let lastUpdated = "lastUpdated"
        
        static let sessions = "sessions"
        static let memberships = "memberships"
        static let booked = "booked"
        
        
        static let isPeriodExpired = "isPeriodExpired"

        struct  `PackageType` {
            static let membership = "Membership"
            static let session = "Session"
        }
        static let type  = "type"

    }
    
    // MARK: - Membership Modal
    struct Membership {
        static let membershipNumber = "membershipNumber"
    }
    
    // MARK: - Membership Package Modal
    struct MembershipPackage {
        static let packageId = "packageId"
        static let packageName = "packageName"
        static let packageType = "packageType"
        static let price = "price"
        static let sessions = "sessions"
        static let validityDays = "validityDays"
        static let expireson = "expireson"
        static let checkin = "checkin"
        static let isCorepass = "is_corepass"
    }
    // MARK: - Membership Company Info Modal
    struct MembershipCompany {
        static let logoUrl = "logoUrl"
        static let name = "name"
        static let departments = "departments"
        static let membershipNumberId = "membershipNumberId"
        static let corporateId = "corporateId"
    }

    // MARK: - Measurement Modal
    struct Measurement {
        static let title = "title"
        static let value = "value"
        static let date = "date"
        static let measurements = "measurements"
        
        static let code = "code"

        // MARK: - Measurement History Modal
        struct History    {
            static let id = "id"
            static let date = "date"
            static let selfieUrl = "selfieUrl"
            static let measurements = "measurements"
            static let takeSelfie = "takeSelfie"
            static let list = "list"
        }
        
    }
    
    // MARK: - Promotions Modal
    struct Promotions    {
        static let  promotionId = "id"
        static let  promotionName = "promotionName"
        static let  discount = "discount"
        static let  promotionImage = "promotionImage"
        static let  promotionURL = "url"
        static let  lastUpdated = "lastUpdated"
        static let  type = "type"
        static let  deep_link_id = "deep_link_id"

    }
    struct CheckIns    {
        static let  checkInClassId = "id"
        static let  checkInClassName = "class_name"
        static let  checkInClassDate = "schedule_date"
        static let  checkInClassImg = "image_url"
        static let  isFree = "is_free"
        static let  facilityName = "facility_name"
    }

    // MARK: - Tags Modal
    struct Tags {
        static let fitness = "fitness"
        static let nutrition = "nutrition"
        static let lifestyle = "lifestyle"
    }
    
    // MARK: - Workout Modal
    struct Workout  {
        static let workoutId = "workoutId"
        
        static let searchResults = "searchResults"
        static let recommended = "recommended"
        static let totalRecords = "totalRecords"
        static let filters = "filters"
        static let level = "level"
        static let typeK = "type"
        
        static let onlyForYou = "onlyForYou"
        static let exploreByFocus = "exploreByFocus"
        static let exploreByType = "exploreByType"

        static let id = "id"
        static let name = "name"
        static let imageUrl = "imageUrl"
        static let duration = "duration"
        static let isFavorite = "isFavorite"
        static let point = "point"

        
        
        // MARK: - Workout Type Modal
        struct `Types`     {
            static let id = "id"
            static let name = "name"
            static let code = "code"
            static let imageUrl = "imageUrl"
            static let lastUpdated = "lastUpdated"
            static let desc = "description"
        }
        
        // MARK: - Workout Tutorial Modal
        struct Tutorial    {
            
            static let id = "id"
            static let name = "name"
            static let point = "point"
            static let duration = "duration"
            static let defaultImageUrl = "defaultImageUrl"
            static let videoUrl = "videoUrl"
            static let videoType = "videoType"
            static let steps = "steps"
            
            static let imageUrl = "imageUrl"
            static let sequence = "sequence"

        }

        // MARK: - Workout Tutorial Modal
        struct History {
            static let page = "page"
            static let pageSize = "pageSize"
            static let totalRecords = "totalRecords"
            static let workoutId = "workoutId"
        }

        // MARK: - Workout Category Modal. Re-named to Level
        struct Category {
            static let id = "id"
            static let name = "name"
            static let tagline = "tagline"
            static let imageUrl = "imageUrl"
            static let code = "code"
        }
        
        // MARK: - Workout Recommended Modal
        struct Recommended {
            static let keyword = "keyword"
            static let filters = "filters"
            static let level = "level"
            static let type = "type"
            static let page = "page"
            static let pageSize = "pageSize"
            static let resetFilter = "resetFilter"
            static let viewAll = "viewAll"
            static let totalRecords = "totalRecords"
            static let searchResults = "searchResults"
            static let workoutCategoryID = "workoutCategoryID"
        }

    }

    // MARK:- Pagination
    struct Pagination {
        static let page = "page"
        static let pageSize = "pageSize"
        static let totalRecord = "totalRecords"
        static let list = "list"
    }

    // MARK: - Department Modal
    struct Department    {
        static let id = "id"
        static let name = "name"
    }

    // MARK: - Invoice Modal
    struct Invoice {
        static let products = "products"
        static let totalAmount = "value"
        static let totalVAT = "vat"
        static let vatRatio = "vatRatio"
        static let description = "description"
        static let name = "name"
        static let quantity = "quantity"
        static let packageId = "package_id"
        static let classId = "class_id"
        static let price = "price"
        static let slots = "slots"
        static let lang = "lang"
        static let timeStamp = "timeStamp"
        static let facilityName = "facility_name"

    }

    // MARK: - Wallet Membership Modal
    struct WalletMembership  {
        static let facilityName = "facilityName"
        static let facilityId = "facilityId"
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let facilityImage = "facilityImage"
        static let packageName = "packageName"
        static let packageId = "packageId"
        static let packageTypeCode = "packageTypeCode"
        static let visits = "visits"
        static let checkin = "checkin"
        static let address = "address"
        static let price = "price"
        static let validity = "validity"
        static let expireson = "expireson"
        static let isCorepass = "isCorepass"
        static let repeatMonthly = "repeatMonthly"
        static let status = "status"
        static let createdDate = "createdDate"
        static let lastUpdated = "lastUpdated"
        static let facilityPhoneNo = "facilityPhoneNo"
        
    }

    // MARK: - Home Categories Modal
    struct HomeCategories  {
        static let profileSteps = "profileSteps"
        static let workouts = "workouts"
        static let workoutTypes = "workoutTypes"
        static let workoutLevels = "workoutLevels"
        static let recomendedArticles = "recomendedArticles"
        static let promotions = "promotions"
    }

    
    
    
    // MARK: - Gamification Action Modal
    struct Action {
        static let id = "button_id"
        static let name = "identifier"
        static let type = "action_type"
        static let isBadge = "is_badge"
        static let points = "points"
    }
    
    
    // MARK: - Gamification Level Modal
    struct Level {
        static let id = "button_id"
        static let name = "identifier"
        static let type = "action_type"
        static let isBadge = "is_badge"
        static let points = "points"
    }
    
    
    // MARK: - Gamification Level Modal
    struct Badge {
        static let id = "badge_id"
        static let name = "name"
        static let desc = "desc"
        static let imageUrl = "image_url"
        static let name_En = "name_en"
        static let userId = "user_id"
        static let points = "points"
    }
    
    struct ActionName {
        static let profileUpdate = "PROFILE_UPDATE_ACTION"
        static let workoutCompleted = "WORKOUTS_ACTION"
        static let readArticle = "BOOKWORM_ACTION"
        static let bodyFat = "BODY_FAT_ACTION"
        static let workoutConsistency = "CONSISTENCY_ACTION"


    }
    // MARK: - Gamification Constants
    struct Gamification {
        static let activityPrefix = "ACTIVITY_"
        static let activitySufix = "_ACTION"
    }
    struct Redeem {
        static let keyType = "key_type"
    }

    
    // MARK: - UserDefaults Constants
    struct UserDefaults {
        struct CloudMessaging {
            static let isDeviceTokenUploaded = "isDeviceTokenUploaded"
            static let isDeviceTokenUploading = "isDeviceTokenUploading"

            static let isClientAppTokenUploaded = "isClientAppTokenUploaded"
            static let isClientAppTokenUploading = "isClientAppTokenUploading"
        }
    }
    
    struct CloudMessaging {
        static let companyName = live
        private static let dev = "DevCoredirection"
        private static let staging = "StagingCoredirection"
        private static let live = "Coredirection"
    }

}
