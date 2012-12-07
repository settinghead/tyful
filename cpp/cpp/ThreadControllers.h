//
//  ThreadControllers.h
//  cpp
//
//  Created by Xiyang Chen on 12/1/12.
//  Copyright (c) 2012 settinghead. All rights reserved.
//

#ifndef __cpp__ThreadControllers__
#define __cpp__ThreadControllers__

#include <pthread.h>

class ThreadControllers
{
    
public:
    
    pthread_mutex_t next_feed_mutex;
    pthread_cond_t next_feed_cv;
    
    pthread_mutex_t next_slap_req_mutex;
    pthread_cond_t next_slap_req_cv;
    
    pthread_mutex_t next_feed_req_mutex;
    pthread_cond_t next_feed_req_cv;
    
    pthread_mutex_t stopping_mutex;
    pthread_cond_t stopping_cv;
    
    
    ThreadControllers()
    {
        pthread_mutex_init(&next_feed_mutex,NULL);
        pthread_cond_init (&next_feed_cv, NULL);
        
        pthread_mutex_init(&next_slap_req_mutex,NULL);
        pthread_cond_init (&next_slap_req_cv, NULL);
        
        pthread_mutex_init(&next_feed_req_mutex,NULL);
        pthread_cond_init (&next_feed_req_cv, NULL);
        
        pthread_mutex_init(&stopping_mutex,NULL);
        pthread_cond_init (&stopping_cv, NULL);
    }
    
    ~ThreadControllers()
    {
        pthread_mutex_destroy(&next_slap_req_mutex);
        pthread_cond_destroy (&next_slap_req_cv);
        
        pthread_mutex_destroy(&next_feed_mutex);
        pthread_cond_destroy (&next_feed_cv);
        
        pthread_mutex_destroy(&next_feed_req_mutex);
        pthread_cond_destroy (&next_feed_req_cv);
        
        pthread_mutex_destroy(&stopping_mutex);
        pthread_cond_destroy (&stopping_cv);
    }
    
    // provide some way to get at letters_
};

#endif /* defined(__cpp__ThreadControllers__) */
