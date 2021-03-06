/*
       Licensed to the Apache Software Foundation (ASF) under one
       or more contributor license agreements.  See the NOTICE file
       distributed with this work for additional information
       regarding copyright ownership.  The ASF licenses this file
       to you under the Apache License, Version 2.0 (the
       "License"); you may not use this file except in compliance
       with the License.  You may obtain a copy of the License at

         http://www.apache.org/licenses/LICENSE-2.0

       Unless required by applicable law or agreed to in writing,
       software distributed under the License is distributed on an
       "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
       KIND, either express or implied.  See the License for the
       specific language governing permissions and limitations
       under the License.
 */

package com.honkmobile;

import android.os.Bundle;

import com.segment.analytics.Analytics;
import com.segment.analytics.android.integrations.google.analytics.GoogleAnalyticsIntegration;

import org.apache.cordova.*;
import com.segment.analytics.Analytics;
import com.segment.analytics.Analytics.LogLevel;
import com.segment.analytics.Properties;
import com.segment.analytics.Properties.Product;
import com.segment.analytics.StatsSnapshot;
import com.segment.analytics.Traits;
import com.segment.analytics.Traits.Address;

public class MainActivity extends CordovaActivity
{
    @Override
    public void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        try {
            Analytics analytics = new Analytics.Builder(getApplicationContext(), "|SEGMENT_KEY|")
                    .collectDeviceId(true)
                    .trackApplicationLifecycleEvents()
                    .use(GoogleAnalyticsIntegration.FACTORY)
                    .build();

            Analytics.setSingletonInstance(analytics);
        // Pretty hacky, but hitting Android back on home doesn't close the
        // Analytics properly, so it tries to rebuild and re-set the singleton
        // again with the same write key, which throws an error
        } catch (IllegalStateException e) {
            // no-op
        }

        // Set by <content src="index.html" /> in config.xml
        loadUrl(launchUrl);
    }
}
