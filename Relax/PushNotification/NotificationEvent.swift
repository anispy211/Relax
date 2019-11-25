//
//  NotificationEvents.swift
//  Worker App
//
//  Created by Aniruddha Kadam on 11/09/19.
//  Copyright © 2019 Aniruddha Kadam. All rights reserved.
//

import Foundation

enum NotificationEvent: String {
    case jobStatusChanged   = "JOB_STATUS_CHANGED"
    case jobLocationChanged = "JOB_LOCATION_CHANGED"
    case jobPriorityChange  = "JOB_PRIORITY_CHANGED"
    case jobTasksChanged    = "JOB_TASKS_CHANGED"
    case jobCancelled       = "JOB_CANCELLED"
    case jobUnassigned      = "JOB_UNASSIGNED"
    case workerJobTypesChanged = "WORKER_JOB_TYPES_CHANGED"
    case workerStatusChanged   = "WORKER_STATUS_CHANGED"
    case workerDeleted         = "WORKER_DELETED"
    case jobRequest            = "JOB_REQUEST"
    case jobAssigned           = "JOB_ASSIGNED"
    case batchCompleted        = "BATCH_COMPLETED"
    case batchJobsOrderChanged = "BATCH_JOBS_ORDER_CHANGED"
    case jobCommentsChanged    = "JOB_COMMENTS_CHANGED"
    case none                  = "none"

    var value: String {
        return self.rawValue
    }
}
