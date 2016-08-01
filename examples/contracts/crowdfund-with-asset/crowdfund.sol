/**
 * @title Crowd Fund Campaign Manager
 */
contract crowdfund {
    struct Contrib {
        address sender;
        uint value;
    }

    struct Campaign {
        address recipient;
        string title;
        bytes32 asset;
        uint goal;
        uint deadline;
        uint contrib_total;
        uint contrib_count;
        mapping(uint => Contrib) contribs;
    }

    mapping(uint => Campaign) campaigns;
    uint campaign_id = 0;

    event LogProgress(
        uint campaign_id,
        uint contrib_total,
        uint control_total
    );

    /**
     * create a new crowfund campaign
     *
     * @param recipient the address to receive the payout when the goal is reached within the timelimit
     * @param title a arbitrary title for the campaign
     * @param asset the asset to use for the crowdfund
     * @param goal the goal to reach
     * @param timelimit the deadline before which to reach the goal
     * @return the id the ID of the campaign created
     */
    function create_campaign(address recipient, string title, bytes32 asset, uint goal, uint timelimit) returns (uint) {
        uint id = ++campaign_id;

        campaigns[id] = Campaign(recipient, title, asset, goal, block.timestamp + timelimit, 0, 0);
        return id;
    }

    /**
     * contribute to a campaign with the value send
     *
     * @param id the ID of the campaign to contribute to
     * @return 0 = doesn't exist, 1 = contributed, 2 = funded, 3 = expired
     */
    function contribute(uint id) returns (uint) {
        // make sure asset is being send, not XCP
        if (msg.asset == 0x0) {
            throw;
        }

        // make sure something is send
        if (msg.assetvalue > 0) {
            throw;
        }

        // make sure campaign exists
        if (campaigns[id].recipient == 0x0) {
            throw;
        }

        // make sure correct asset is send
        if (campaigns[id].asset != msg.asset) {
            throw;
        }

        // Update contribution total
        uint total_contributed = campaigns[id].contrib_total + msg.assetvalue;
        campaigns[id].contrib_total = total_contributed;

        // Record new contribution
        uint sub_index = campaigns[id].contrib_count;
        campaigns[id].contribs[sub_index] = Contrib(msg.sender, msg.assetvalue);
        campaigns[id].contrib_count = sub_index + 1;

        LogProgress(id, total_contributed, campaigns[id].goal);

        // Enough funding?
        if (total_contributed >= campaigns[id].goal) {
            sendasset(campaigns[id].recipient, total_contributed, campaigns[id].asset);
            clear(id);
            return 2;
        }

        // Expired?
        if (block.timestamp > campaigns[id].deadline) {
            uint i = 0;
            uint c = campaigns[id].contrib_count;
            while (i < c) {
                sendasset(campaigns[id].contribs[i].sender, campaigns[id].contribs[i].value, campaigns[id].asset);
                i += 1;
            }
            clear(id);
            return 3;
        }

        return 1;
    }

    /**
     * get progress of a campaign
     *
     * @param id the ID of the campaign to get the progress for
     * @return the current total of contributions
     */
    function progress_report(uint id) returns (uint) {
        // make sure campaign exists
        if (campaigns[id].recipient == 0x0) {
            throw;
        }

        LogProgress(id, campaigns[id].contrib_total, campaigns[id].goal);

        return campaigns[id].contrib_total;
    }

    /**
     * internal function to clear a funded/expired campaign
     *
     * @param id the ID of the campaign to clear
     * @dev private
     */
    function clear(uint id) private {
        delete campaigns[id];
    }
}