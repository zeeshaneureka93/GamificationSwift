//
//  ArticleDetail+AppProperties.swift
//  CoreDirection
//
//  Created by Ahmar on 8/22/17.
//  Copyright © 2017 Rebel Technology. All rights reserved.
//

import Foundation
import CoreData

extension ArticleDetail   {
    
    class func syncWith(article: Article, data: [String: Any])   {
        let articleDetail = CoreDataManager.insert(object: data, entityName: Entity.articleDetail) as! ArticleDetail
        article.detail = articleDetail
        CoreDataStack.save()
    }

}

