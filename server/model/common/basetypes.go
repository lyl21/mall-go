package common

import (
	"database/sql/driver"
	"encoding/json"
	"errors"
	"time"
)

type JSONMap map[string]interface{}

func (m JSONMap) Value() (driver.Value, error) {
	if m == nil {
		return nil, nil
	}
	return json.Marshal(m)
}

func (m *JSONMap) Scan(value interface{}) error {
	if value == nil {
		*m = make(map[string]interface{})
		return nil
	}
	var err error
	switch value.(type) {
	case []byte:
		err = json.Unmarshal(value.([]byte), m)
	case string:
		err = json.Unmarshal([]byte(value.(string)), m)
	default:
		err = errors.New("basetypes.JSONMap.Scan: invalid value type")
	}
	if err != nil {
		return err
	}
	return nil
}

type DateTime struct {
	time.Time
}

func (t DateTime) MarshalJSON() ([]byte, error) {
	formatted := t.Format("2006-01-02 15:04:05")
	return json.Marshal(formatted)
}

func (t *DateTime) UnmarshalJSON(data []byte) error {
	var s string
	if err := json.Unmarshal(data, &s); err != nil {
		return err
	}
	parsed, err := time.Parse("2006-01-02T15:04:05Z07:00", s)
	if err != nil {
		parsed, err = time.Parse("2006-01-02 15:04:05", s)
		if err != nil {
			return err
		}
	}
	t.Time = parsed
	return nil
}

func (t DateTime) Value() (driver.Value, error) {
	return t.Time, nil
}

func (t *DateTime) Scan(value interface{}) error {
	if value == nil {
		return nil
	}
	switch v := value.(type) {
	case time.Time:
		t.Time = v
		return nil
	case []byte:
		parsed, err := time.Parse("2006-01-02 15:04:05", string(v))
		if err != nil {
			parsed, err = time.Parse(time.RFC3339, string(v))
			if err != nil {
				return err
			}
		}
		t.Time = parsed
		return nil
	case string:
		parsed, err := time.Parse("2006-01-02 15:04:05", v)
		if err != nil {
			parsed, err = time.Parse(time.RFC3339, v)
			if err != nil {
				return err
			}
		}
		t.Time = parsed
		return nil
	}
	return errors.New("DateTime.Scan: invalid value type")
}

type TreeNode[T any] interface {
	GetChildren() []T
	SetChildren(children T)
	GetID() int
	GetParentID() int
}
