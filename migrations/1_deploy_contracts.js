const Marketplace = artifacts.require("Marketplace");

module.exports = function(deployer) {
  deployer.deploy(Marketplace, 0xc71fDbDE4938D7605528FD998a7a5F5420eAbB6A);
};
