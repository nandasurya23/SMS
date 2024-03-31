package db

import (
	"database/sql"
	"fmt"
	"smsbackends/config"

	_ "github.com/go-sql-driver/mysql"
)

func ConnectDB() (*sql.DB, error) {
    dataSource := fmt.Sprintf("%s:%s@tcp(%s:%s)/%s", config.DB_USERNAME, config.DB_PASSWORD, config.DB_HOST, config.DB_PORT, config.DB_NAME)
    db, err := sql.Open("mysql", dataSource)
    if err != nil {
        return nil, err
    }
    err = db.Ping()
    if err != nil {
        return nil, err
    }
    return db, nil
}
