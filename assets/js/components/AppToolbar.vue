<template>
  <v-toolbar max-height="64px" color="#124475">
    <v-toolbar-title class="white--text">
      <v-img
        max-height="50px"
        max-width="250"
        src="https://plsadaptive.s3.amazonaws.com/eco/images/speaker_companies/ZOootY7YWE4wCUyfx9ZV2vsn90LHfEaDwpy432dQ.png"
      >
      </v-img>
    </v-toolbar-title>
    <v-spacer></v-spacer>
    <v-avatar color="white">
      <span class="dark-blue--text headline">{{ avatarText }}</span>
    </v-avatar>
  </v-toolbar>
</template>

<script>
export default {
  name: "AppToolbar",
  computed: {
    avatarText: function () {
      return this.user.charAt(0);
    },
  },
};
</script>
