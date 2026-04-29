package client

import (
	"github.com/flipped-aurora/gin-vue-admin/server/model/store"
	storeService "github.com/flipped-aurora/gin-vue-admin/server/service/store"
	"github.com/flipped-aurora/gin-vue-admin/server/utils"
	"github.com/gin-gonic/gin"
)

type ClientUserApi struct{}

var ClientUserServiceApp = new(ClientUserApi)

type LoginReq struct {
	PhoneNumber string `json:"phoneNumber" binding:"required"`
	Password    string `json:"password" binding:"required"`
}

type LoginResp struct {
	User  store.MxUser `json:"user"`
	Token string       `json:"token"`
}

func (a *ClientUserApi) Login(c *gin.Context) {
	var req LoginReq
	if err := c.ShouldBindJSON(&req); err != nil {
		ClientFailWithMessage("请求参数错误", c)
		return
	}

	user, err := storeService.UserServiceApp.GetMxUserByPhone(req.PhoneNumber)
	if err != nil {
		ClientFailWithMessage("用户不存在", c)
		return
	}

	if user.IsDelete == 1 {
		ClientFailWithMessage("该账号已注销", c)
		return
	}

	if user.Password != req.Password {
		ClientFailWithMessage("密码错误", c)
		return
	}

	token, err := utils.GenerateClientToken(user.UserId, user.PhoneNumber)
	if err != nil {
		ClientFailWithMessage("生成token失败", c)
		return
	}

	ClientResult(SUCCESS, LoginResp{
		User:  user,
		Token: token,
	}, "操作成功", c)
}

func (a *ClientUserApi) Logout(c *gin.Context) {
	token := utils.GetToken(c)
	if token != "" {
		utils.ClearClientToken(token)
	}
	ClientOkWithMessage("退出成功", c)
}

func (a *ClientUserApi) RefreshToken(c *gin.Context) {
	userId, _ := c.Get("clientUserId")
	phone, _ := c.Get("clientPhone")

	token, err := utils.GenerateClientToken(userId.(int64), phone.(string))
	if err != nil {
		ClientFailWithMessage("刷新token失败", c)
		return
	}

	ClientOkWithData(gin.H{"token": token}, c)
}

func (a *ClientUserApi) GetUserInfo(c *gin.Context) {
	userId, _ := c.Get("clientUserId")

	user, err := storeService.UserServiceApp.GetMxUser(userId.(int64))
	if err != nil {
		ClientFailWithMessage("获取用户信息失败", c)
		return
	}

	ClientOkWithData(user, c)
}

func (a *ClientUserApi) Register(c *gin.Context) {
	var req struct {
		PhoneNumber string `json:"phoneNumber" binding:"required"`
		Password    string `json:"password" binding:"required"`
		Name        string `json:"name"`
	}

	if err := c.ShouldBindJSON(&req); err != nil {
		ClientFailWithMessage("请求参数错误", c)
		c.Abort()
		return
	}

	_, err := storeService.UserServiceApp.GetMxUserByPhone(req.PhoneNumber)
	if err == nil {
		ClientFailWithMessage("该手机号已注册", c)
		c.Abort()
		return
	}

	newUser := store.MxUser{
		PhoneNumber: req.PhoneNumber,
		Password:   req.Password,
		Name:       req.Name,
	}

	if err := storeService.UserServiceApp.CreateMxUser(newUser); err != nil {
		ClientFailWithMessage("注册失败", c)
		c.Abort()
		return
	}

	ClientOkWithMessage("注册成功", c)
}

func (a *ClientUserApi) ChangePassword(c *gin.Context) {
	var req struct {
		PhoneNumber  string `json:"phoneNumber" binding:"required"`
		OldPassword  string `json:"oldPassword" binding:"required"`
		NewPassword  string `json:"newPassword" binding:"required"`
	}

	if err := c.ShouldBindJSON(&req); err != nil {
		ClientFailWithMessage("请求参数错误", c)
		c.Abort()
		return
	}

	user, err := storeService.UserServiceApp.GetMxUserByPhone(req.PhoneNumber)
	if err != nil {
		ClientFailWithMessage("用户不存在", c)
		c.Abort()
		return
	}

	if user.Password != req.OldPassword {
		ClientFailWithMessage("原密码错误", c)
		c.Abort()
		return
	}

	user.Password = req.NewPassword
	if err := storeService.UserServiceApp.UpdateMxUser(user); err != nil {
		ClientFailWithMessage("修改密码失败", c)
		c.Abort()
		return
	}

	ClientOkWithMessage("修改密码成功", c)
}
