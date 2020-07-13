<template>
  <Form
    ref="formData"
    :model="formData"
    :rules="formRule"
    :label-width="80"
    label-position="right"
    style="width: 500px;"
  >
    <FormItem label="用户名" prop="username">
      <Input v-model="formData.username" placehoder="请输入用户名" />
    </FormItem>

    <FormItem label="密码" prop="password">
      <Input v-model="formData.password" placehoder="请输入密码" />
    </FormItem>

    <FormItem label="手机号码" prop="phone">
      <Input v-model="formData.phone" placehoder="请输入手机号码" />
    </FormItem>
  </Form>
</template>
<script>
const resetData = () => ({
  username: "",
  password: "",
  phone: "",
})
export default {
  name: "MyForm",
  data: () => ({
    formData: {
      username: "",
      password: "",
      phone: "",
    },
    formRule: {
      username: [{ message: "必填项", required: true, trigger: "blur" }],
      password: [
        { message: "密码是必填项", required: true, trigger: "change" },
        { message: "长度必须在6到10位之间", min: 6, max: 10 },
      ],
      phone: [{ message: "手机号码是必填项", required: true, trigger: "blur" }],
    },
  }),
  methods: {
    resetData(data) {
      if (!data) {
        this.formData = data
        return
      }
      this.formData = resetData()
    },
    handleValidate() {
      return new Promise((resolve) => {
        this.$refs.formData.validate((valid) => {
          resolve(valid)
        })
      })
    },
    getFormData() {
      return this.formData
    },
  },
}
</script>
