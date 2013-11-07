<overlay>
  action: insert
  after: setupForTesting();
</overlay>
    testingMode({
      server: function() { Em.testing = false; }
    });
