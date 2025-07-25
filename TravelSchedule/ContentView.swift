//
//  ContentView.swift
//  TravelSchedule
//
//  Created by Pavel Seleznev on 6/26/25.
//

import SwiftUI
import OpenAPIURLSession

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                testFetchScheduleBetweenStations()
                testFetchScheduleStations()
                testFetchStations()
                testFetchNearestCity()
                testFetchCarrierResponse()
                testFetchCopyright()
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 15) {
                testFetchAllStations()
            }
        }
    }
    
    private let apiKey = "6db1daa7-c560-4544-9088-1717e55fc4cf"
    
    private func testFetchScheduleBetweenStations() {
        Task {
            do {
                let client = Client(
                    serverURL: try Servers.Server1.url(),
                    transport: URLSessionTransport()
                )
                
                let service = ScheduleBetweenStationsService(
                    client: client,
                    apikey: apiKey
                )
                
                print("Fetching schedule...")
                let schedule = try await service.getScheduleBetweenStations(
                    from: "s9600941",
                    to: "s9601368"
                )
                print("Successfully fetched schedule: \(schedule)")
                
                if let uid = schedule.segments?.first?.thread?.uid {
                    let routeStationsService = ListRouteStationsService(client: client, apikey: apiKey)
                    let response = try await routeStationsService.getRouteStations(uid: uid)
                    print("Successfully fetched route stations: \(response)")
                } else {
                    print("UID not found in first segment.")
                }
            } catch {
                print("Error fetching schedule: \(error)")
            }
        }
    }
    
    private func testFetchScheduleStations() {
        Task {
            do {
                let client = Client(
                    serverURL: try Servers.Server1.url(),
                    transport: URLSessionTransport()
                )
                
                let service = ScheduleStationsService(
                    client: client,
                    apikey: apiKey
                )
                
                print("Fetching stationSchedule...")
                let response = try await service.getStationSchedule(
                    stationCode: "s9600941"
                )
                print("Successfully fetched stationSchedule: \(response)")
            } catch {
                print("Error fetching stationSchedule: \(error)")
            }
        }
    }
    
    private func testFetchStations() {
        Task {
            do {
                let client = Client(
                    serverURL: try Servers.Server1.url(),
                    transport: URLSessionTransport()
                )
                
                let service = NearestStationsService(
                    client: client,
                    apikey: apiKey
                )
                
                print("Fetching stations...")
                let response = try await service.getNearestStations(
                    lat: 59.864177, // Example coordinates
                    lng: 30.319163, // Example coordinates
                    distance: 50    // Example distance
                )
                
                print("Successfully fetched stations: \(response)")
            } catch {
                print("Error fetching stations: \(error)")
            }
        }
    }
    
    private func testFetchNearestCity() {
        Task {
            do {
                let client = Client(
                    serverURL: try Servers.Server1.url(),
                    transport: URLSessionTransport()
                )
                
                let service = NearestSettlementService(
                    client: client,
                    apikey: apiKey
                )
                
                print("Fetching nearestCity...")
                let response = try await service.getNearestCity(
                    lat: 50.44973,
                    lng: 40.125282)
                print("Successfully fetched nearestCity: \(response)")
            } catch {
                print("Error fetching nearestCity: \(error)")
            }
        }
    }
    
    private func testFetchCarrierResponse() {
        Task {
            do {
                let client = Client(
                    serverURL: try Servers.Server1.url(),
                    transport: URLSessionTransport()
                )
                
                let service = CarrierService(
                    client: client,
                    apikey: apiKey
                )
                
                print("Fetching carrierResponse...")
                let response = try await service.getCarrierInfo(
                    code: "TK",        // Turkish Airlines IATA code
                    system: "iata"     // Specify lookup system
                )
                print("Successfully fetched carrierResponse: \(response)")
            } catch {
                print("Error fetching carrierResponse: \(error)")
            }
        }
    }
    
    private func testFetchCopyright() {
        Task {
            do {
                let client = Client(
                    serverURL: try Servers.Server1.url(),
                    transport: URLSessionTransport()
                )
                
                let service = CopyrightService(
                    client: client,
                    apikey: apiKey
                )
                
                print("Fetching copyright...")
                let response = try await service.getCopyright(
                    format: .json
                )
                print("Successfully fetched copyright: \(response)")
            } catch {
                print("Error fetching copyright: \(error)")
            }
        }
    }
    
    private func testFetchAllStations() {
        Task {
            do {
                let client = Client(
                    serverURL: try Servers.Server1.url(),
                    transport: URLSessionTransport()
                )
                
                let service = AllStationsService(
                    client: client,
                    apikey: apiKey
                )
                
                print("Fetching allStations...")
                let response = try await service.getAllStations()
                print("Successfully fetched allStations: \(response)")
            } catch {
                print("Error fetching allStations: \(error)")
            }
        }
    }
}

#Preview {
    ContentView()
}
