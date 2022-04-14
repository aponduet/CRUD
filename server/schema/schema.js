const graphql = require("graphql");
const userTable = require("../model/db_model");

const {
  GraphQLObjectType,
  GraphQLString,
  GraphQLID,
  GraphQLList,
  GraphQLSchema,
  GraphQLNonNull,
} = graphql;

const UserType = new GraphQLObjectType({
  name: "GQL_User_Type",
  fields: () => ({
    id: { type: GraphQLID },
    name: { type: GraphQLString },
    age: { type: GraphQLString },
    sex: { type: GraphQLString },
  }),
});

const RootQuery = new GraphQLObjectType({
  name: "AllQuery",
  fields: {
    user: {
      type: new GraphQLList(UserType),
      resolve: async (parent, args) => {
        return await userTable.find({});
      },
    },
  },
});

const Mutation = new GraphQLObjectType({
  name: "AllMutations",
  fields: {
    addUser: {
      type: UserType,
      args: {
        name: { type: new GraphQLNonNull(GraphQLString) },
        age: { type: new GraphQLNonNull(GraphQLString) },
        sex: { type: new GraphQLNonNull(GraphQLString) },
      },
      resolve: async (parent, args) => {
        let TableData = await new userTable({
          name: args.name,
          age: args.age,
          sex: args.sex,
        });
        return TableData.save();
      },
    },
    deleteUser: {
      type: UserType,
      args: { id: { type: new GraphQLNonNull(GraphQLID) } },
      resolve: async (parent, args) => {
        let TableData = await userTable.deleteOne({ _id: args.id });
        return TableData;
      },
    },
    updateUser: {
      type: UserType,
      args: {
        id: { type: new GraphQLNonNull(GraphQLID) },
        name: { type: new GraphQLNonNull(GraphQLString) },
        age: { type: new GraphQLNonNull(GraphQLString) },
        sex: { type: new GraphQLNonNull(GraphQLString) },
      },
      resolve: async (parent, args) => {
        const name = args.name;
        let TableData = await userTable.updateOne(
          { _id: args.id },
          { name: args.name, age: args.age, sex: args.sex },
          { upsert: true }
        );
        return TableData;
      },
    },
  },
});

module.exports = new GraphQLSchema({
  query: RootQuery,
  mutation: Mutation,
});
