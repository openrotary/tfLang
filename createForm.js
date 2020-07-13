const createItem = (data) => {
  return `
  <FormItem label="${data.label}" prop="${data.key}">
        <${data.tag} v-model="formData.${data.key}" placehoder="${data.placehoder}" />
  </FormItem>
  `
}

const createRule = (data) => {
  const createRuleItem = (rule) => {
    return `
        { message: '${rule.warn}', ${rule.valid.map((it) => it).join(",")}}
      `
  }
  return `
    ${data.key}: [
        ${data.rules.map((it) => createRuleItem(it)).join(",")}
    ]
    `
}

const createForm = (json) => {
  const data = JSON.parse(json)
  return `<template>
        <Form ref="formData" :model="formData" :rules="formRule" ${data.root.attr.join(
          " "
        )}>
            ${data.root.children.map((item) => createItem(item)).join("")}
        </Form>
  </template>
  <script>
  const resetData = () => ({
      ${data.root.children.map((item) => item.key + ": ''").join(",")}
  })
  export default {
      name: 'MyForm',
      data: () => ({
          formData: {
              ${data.root.children.map((item) => item.key + ": ''").join(",")}
          },
          formRule: {
              ${data.root.children.map((item) => createRule(item)).join(",")}
          }
      }),
      methods: {
          resetData(data) {
            if(!data) {
                this.formData = data
                return
            }
            this.formData = resetData()
          },
          handleValidate() {
              return new Promise(resolve => {
                this.$refs.formData.validate((valid) => {
                    resolve(valid)
                })
              })
          },
          getFormData() {
              return this.formData
          }
      }
  }
  </script>
  `
}

module.exports = createForm
