<template>
  <v-app>
    <AppToolbar />
    <v-main>
      <v-container grid-list-md>
        <router-view/>
      </v-container>
    </v-main> 
    
  </v-app>
</template>

<script>
import AppToolbar from "./components/AppToolbar.vue";

export default {
  name: 'App',
  components: {
    AppToolbar,
    
  }
}
</script>
