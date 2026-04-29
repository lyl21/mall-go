package utils

import (
	"context"
	"time"

	"github.com/flipped-aurora/gin-vue-admin/server/global"
	jwt "github.com/golang-jwt/jwt/v5"
	"github.com/google/uuid"
)

type ClientClaims struct {
	UserId      int64  `json:"userId"`
	PhoneNumber string `json:"phoneNumber"`
	Role        string `json:"role"`
	jwt.RegisteredClaims
}

func GenerateClientToken(userId int64, phoneNumber string) (string, error) {
	j := NewJWT()
	ep, _ := ParseDuration(global.GVA_CONFIG.JWT.ExpiresTime)

	claims := ClientClaims{
		UserId:      userId,
		PhoneNumber: phoneNumber,
		Role:        "client",
		RegisteredClaims: jwt.RegisteredClaims{
			Audience:  jwt.ClaimStrings{"CLIENT"},
			NotBefore: jwt.NewNumericDate(time.Now().Add(-1000)),
			ExpiresAt: jwt.NewNumericDate(time.Now().Add(ep)),
			Issuer:    global.GVA_CONFIG.JWT.Issuer,
			ID:        uuid.New().String(),
		},
	}

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	tokenString, err := token.SignedString(j.SigningKey)
	if err != nil {
		return "", err
	}

	dr, _ := ParseDuration(global.GVA_CONFIG.JWT.ExpiresTime)
	err = global.GVA_REDIS.Set(context.Background(), "client:token:"+tokenString, userId, dr).Err()
	if err != nil {
		return "", err
	}

	return tokenString, nil
}

func ParseClientToken(tokenString string) (*ClientClaims, error) {
	j := NewJWT()
	token, err := jwt.ParseWithClaims(tokenString, &ClientClaims{}, func(token *jwt.Token) (i interface{}, e error) {
		return j.SigningKey, nil
	})

	if err != nil {
		return nil, err
	}

	if claims, ok := token.Claims.(*ClientClaims); ok && token.Valid {
		return claims, nil
	}

	return nil, TokenInvalid
}

func ClearClientToken(tokenString string) error {
	ctx := context.Background()
	global.GVA_REDIS.Del(ctx, "client:token:"+tokenString)
	return nil
}

func ValidateClientToken(tokenString string) (bool, *ClientClaims) {
	claims, err := ParseClientToken(tokenString)
	if err != nil {
		return false, nil
	}

	ctx := context.Background()
	result, err := global.GVA_REDIS.Get(ctx, "client:token:"+tokenString).Result()
	if err != nil || result == "" {
		return false, nil
	}

	return true, claims
}
