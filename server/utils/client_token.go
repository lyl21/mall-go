package utils

import (
	"context"
	"errors"
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
	if err := global.GVA_REDIS.Del(ctx, "client:token:"+tokenString).Err(); err != nil {
		return err
	}
	return nil
}

// ValidateClientToken 校验客户端token
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

// MiniProgramClaims 小程序用户 JWT 声明
type MiniProgramClaims struct {
	OpenId   string `json:"openId"`
	WxUserId string `json:"wxUserId"`
	Role     string `json:"role"`
	jwt.RegisteredClaims
}

// GenerateMiniToken 为小程序用户生成 JWT Token（自定义登录态）
func GenerateMiniToken(openId, wxUserId string) (string, error) {
	if openId == "" || wxUserId == "" {
		return "", errors.New("openId 和 wxUserId 不能为空")
	}
	j := NewJWT()
	ep, _ := ParseDuration(global.GVA_CONFIG.JWT.ExpiresTime)

	claims := MiniProgramClaims{
		OpenId:   openId,
		WxUserId: wxUserId,
		Role:     "mini_program",
		RegisteredClaims: jwt.RegisteredClaims{
			Audience:  jwt.ClaimStrings{"MINI_PROGRAM"},
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
	err = global.GVA_REDIS.Set(context.Background(), "mini:token:"+tokenString, wxUserId, dr).Err()
	if err != nil {
		return "", err
	}

	return tokenString, nil
}

// ValidateMiniToken 校验小程序 JWT Token
func ValidateMiniToken(tokenString string) (bool, *MiniProgramClaims) {
	j := NewJWT()
	token, err := jwt.ParseWithClaims(tokenString, &MiniProgramClaims{}, func(token *jwt.Token) (i interface{}, e error) {
		return j.SigningKey, nil
	})
	if err != nil {
		return false, nil
	}

	claims, ok := token.Claims.(*MiniProgramClaims)
	if !ok || !token.Valid {
		return false, nil
	}

	ctx := context.Background()
	result, err := global.GVA_REDIS.Get(ctx, "mini:token:"+tokenString).Result()
	if err != nil || result == "" {
		return false, nil
	}

	return true, claims
}

// ClearMiniToken 清除小程序 JWT Token
func ClearMiniToken(tokenString string) error {
	ctx := context.Background()
	return global.GVA_REDIS.Del(ctx, "mini:token:"+tokenString).Err()
}
