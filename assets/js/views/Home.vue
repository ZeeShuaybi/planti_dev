<template>
  <div class="home">
    <v-container>
      <div class="d-flex flex-row">
        <div class="pa-3">
          <v-text-field
            name="search"
            label="Name"
            clearable
            v-model="filter1"
            autocomplete="off"
            solo-inverted
          ></v-text-field>
        </div>
        <v-spacer />
        <div class="pa-3">
          <v-text-field
            name="search"
            label="Family"
            clearable
            v-model="filter2"
            autocomplete="off"
            solo-inverted
          ></v-text-field>
        </div>
      </div>

      <v-divider />

      <div class="mx-3 my-2 d-flex font-italic">
        There are
        <span style="display: inline-block; width: 7px"></span>
        <p class="red--text">{{ filteredRows.length }}</p>
        <span style="display: inline-block; width: 7px"></span>
        results
      </div>
    </v-container>

    <div>
      <v-simple-table fixed-header height="500px">
        <template v-slot:default>
          <thead v-if="filteredRows.length > 0">
            <tr class="text-left">
              <th>Common Name</th>
              <th>Scientific Name</th>
              <th>Family</th>
              <th>Perennial</th>
              <th>Color</th>
              <th>
                <v-badge color="grey" :content="groups.length - 1"
                  >Group</v-badge
                >
              </th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="plant in filteredRows" :key="plant.id">
              <td>
                {{ plant.common_name }}
              </td>
              <td>
                {{ plant.sci_name }}
              </td>
              <td>
                {{ plant.family }}
              </td>
              <td>
                {{ plant.is_perennial }}
              </td>
              <td>
                {{ plant.color }}
              </td>
              <td>
                <v-combobox
                  list="groups"
                  v-model="plant.group"
                  @keyup.enter="addGroup(plant.group)"
                  @input="mark(plant.id)"
                  item-color
                  append-icon
                  clearable
                ></v-combobox>
              </td>
            </tr>
          </tbody>
        </template>
      </v-simple-table>
    </div>

    <div class="text-center ma-2">
      <v-btn dark @click="saveGroups"> Save </v-btn>
      <v-snackbar v-model="saved">
        Your Groups were successfully saved!
        <template v-slot:action="{ attrs }">
          <v-btn color="pink" text v-bind="attrs" @click="saved = false">
            Close
          </v-btn>
        </template>
      </v-snackbar>
    </div>

    <datalist id="groups">
      <option v-for="(g, index) in groups" :key="index" :value="g" />
    </datalist>
  </div>
</template>

<script>
import axios from "axios";

export default {
  name: "Home",
  mounted() {
    axios
      .get(`api/all-plants/user/${this.user}`)
      .then((response) => {
        console.log("get all-plants response: ", response.data);
        this.tableData = response.data;
        this.tableData.forEach((plant) => {
          this.addGroup(plant.group);
        });
      })
      .catch((err) => {
        console.log("Error retrieving plant data:", err);
      });
  },

  data: () => ({
    tableData: [],
    groups: [],
    saved: false,
    marked: [],
    filter1: "",
    filter2: "",
  }),

  computed: {
    filteredRows: function () {
      return this.tableData.filter((plant) => {
        let searchTerm1 = "";
        let searchTerm2 = "";
        if (this.filter1) {
          searchTerm1 = this.filter1.toLowerCase();
        }
        if (this.filter2) {
          searchTerm2 = this.filter2.toLowerCase();
        }
        const common_name = plant.common_name.toLowerCase();
        const sci_name = plant.sci_name.toLowerCase();
        const family = plant.family.toLowerCase();
        //const color = plant.color.toLowerCase();
        //let group = "";
        //if(plant.group) {group = plant.group.toLowerCase()};

        return (
          (common_name.includes(searchTerm1) ||
            sci_name.includes(searchTerm1)) &&
          family.includes(searchTerm2)
        );
        //|| sci_name.includes(searchTerm)
        //|| color.includes(searchTerm)
        //|| group.includes(searchTerm);
      });
    },
  },

  methods: {
    addGroup(group) {
      if (!this.groups.includes(group)) {
        this.groups.push(group);
      }
    },

    saveGroups() {
      this.marked.forEach((id) => {
        axios
          .post("api/save-groups", {
            user: this.user,
            plant_id: id,
            group: this.tableData.find((plant) => plant.id == id).group,
          })
          .then((response) => {
            console.log("save-groups response:", response.data);
            this.saved = true;
          })
          .catch((err) => {
            console.log("Error saving groups:", err);
          });
      });
    },

    mark(id) {
      if (!this.marked.includes(id)) {
        this.marked.push(id);
        console.log(this.marked);
      }
    },
  },
};
</script>
