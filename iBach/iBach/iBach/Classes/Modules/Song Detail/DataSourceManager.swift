//
//  DataSourceManager.swift
//  iBach
//
//  Created by Neven Travaš on 29/01/2019.
//  Copyright © 2019 Petar Jedek. All rights reserved.
//

import Foundation


class DataSourceManager {
    
    public func currentDataSource() -> SongDetailDatasource {
        
        let datasourceRawValue: String = UserDefaults.standard.string(forKey: "songDataSource") ?? ""
        let defaultDatasource: DataSourceType = .musicxmatch
        let selectedDatasourceType: DataSourceType = DataSourceType(rawValue: datasourceRawValue) ?? defaultDatasource
        
        var datasource: SongDetailDatasource
        switch selectedDatasourceType {
        case .musicxmatch:
            datasource = MusicMatchSongDetailsDataSource()
        case .songLyrics:
            datasource = MusicMatchSongDetailsDataSource() // TODO: dok dodamo novi datasource promjeni klasu
        case .myLyrics:
            datasource = MusicMatchSongDetailsDataSource()
            
            
        }
        return datasource
    }
}
