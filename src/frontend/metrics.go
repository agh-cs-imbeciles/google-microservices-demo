// Copyright 2018 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package main

import (
	"github.com/prometheus/client_golang/prometheus"
	"github.com/prometheus/client_golang/prometheus/promauto"
)

var (
	httpRequestsTotal = promauto.NewCounterVec(
		prometheus.CounterOpts{
			Name: "http_requests_total",
			Help: "Total number of HTTP requests by status code and method",
		},
		[]string{"status", "method"},
	)

	httpRequestDuration = promauto.NewHistogramVec(
		prometheus.HistogramOpts{
			Name:    "http_request_duration_seconds",
			Help:    "Duration of HTTP requests in seconds",
			Buckets: prometheus.DefBuckets,
		},
		[]string{"handler"},
	)

	productListRequestsTotal = promauto.NewCounter(
		prometheus.CounterOpts{
			Name: "product_list_requests_total",
			Help: "Total number of product list page requests",
		},
	)

	addToCartTotal = promauto.NewCounter(
		prometheus.CounterOpts{
			Name: "add_to_cart_total",
			Help: "Total number of add-to-cart actions",
		},
	)

	checkoutTotal = promauto.NewCounter(
		prometheus.CounterOpts{
			Name: "checkout_total",
			Help: "Total number of checkout actions",
		},
	)
)
