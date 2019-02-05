const { GraphQLServer } = require('graphql-yoga');
require('dotenv').config();
const cors = require('cors');
const express = require('express');

const opts = {
  port: process.env.PORT || 4000
};

const resolvers = require('./resolvers');

const server = new GraphQLServer({
  typeDefs: './src/schema.graphql',
  resolvers,
  opts
});

server.express.use(express.static('../../'));

server.start(() => console.log(`Server is running at http://localhost:${opts.port}`));
