<template>
  <Form
    ref="formData"
    :model="formData"
    :rules="formRule"
    :label-width="80"
    label-position="left"
  >
    <FormItem label="用户名">
      <Input v-model="username" placehoder="请输入用户名" />
    </FormItem>

    <FormItem label="密码">
      <Input v-model="password" placehoder="请输入密码" />
    </FormItem>
  </Form>
</template>
<script>
const resetData = () => ({
  username: "",
  password: "",
})
export default {
  name: "MyForm",
  data: () => ({
    formData: {
      username: "",
      password: "",
    },
    formRule: {
      username: [{ require: true, message: "必填项", trigger: "blur" }],
      password: [
        { require: true, message: "密码是必填项", trigger: "change" },
        { require: true, message: "长度必须在6到24位之间", min: 6, max: 23 },
      ],
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
